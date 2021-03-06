#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Well, build tools are available only on MacOS
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Bundling QGIS"
else
  echo "Unable to bundle QGIS binaries on $OSTYPE"
  exit 1;
fi

function install_name_add_rpath {
  if [ ! -f "$2" ]; then
    error "Missing $2 (install_name_add_rpath)"
  fi
  try install_name_tool -add_rpath $1 $2
}

function install_name_delete_rpath {
  if [ ! -f "$2" ]; then
    error "Missing $2 (install_name_delete_rpath)"
  fi
  try install_name_tool -delete_rpath $1 $2
}

function install_name_change {

  if [ ! -f "$3" ]; then
    error "Missing $3 (install_name_change)"
  fi
  try install_name_tool -change $1 $2 $3
}

function install_name_id {

  if [ ! -f "$2" ]; then
    error "Missing $2 (install_name_id)"
  fi
  try install_name_tool -id $1 $2
}

source $DIR/config.conf
source $DIR/../qgis_deps/config.conf
if [ -d $ROOT_OUT_PATH/stage ]; then
       info "Using qgis_deps: $ROOT_OUT_PATH/stage"
else
       error "Missing qgis_deps directory '$ROOT_OUT_PATH/stage' not found."
fi

source $ROOT_OUT_PATH/stage/qgis-deps.config

# FIND all modules - the order does not matter here
MODULES=
for dir in `dirname $0`/recipes/*/
do
    dir=${dir%*/}
    MODULES="$MODULES ${dir##*/}"
done

# COMMANDS
RSYNCDIR="rsync -r"
CP=cp

function env_var_exists() {
  VAR=$1
  if [ "X$VAR" == "X" ]; then
     error "Missing config variable $VAR"
  fi
}

function run_prepare_bundle_dir() {
  rm -rf $BUNDLE_DIR
  mkdir -p $BUNDLE_DIR
  mkdir -p $BUNDLE_CONTENTS_DIR
  mkdir -p $BUNDLE_FRAMEWORKS_DIR
  mkdir -p $BUNDLE_RESOURCES_DIR
  mkdir -p $BUNDLE_MACOS_DIR
  mkdir -p $BUNDLE_BIN_DIR
  mkdir -p $BUNDLE_PLUGINS_DIR
  mkdir -p $BUNDLE_LIB_DIR
}

function run_check() {
  for module in ${MODULES[*]}; do
    fn=$(echo check_$module)
    debug "Call $fn"
    $fn
  done
}

function run_bundle() {
  for module in ${MODULES[*]}; do
    fn=$(echo bundle_$module)
    debug "Call $fn"
    $fn
  done
}

function run_postbundle() {
  for module in ${MODULES[*]}; do
    fn=$(echo postbundle_$module)
    debug "Call $fn"
    $fn
  done
}

function run_source_modules() {
  for module in ${MODULES[*]}; do
    source $RECIPES_PATH/$module/recipe.sh
  done
}

function run_add_config_info() {
  for module in ${MODULES[*]}; do
    fn=$(echo add_config_info_$module)
    debug "Call $fn"
    $fn
  done
}

function check_binary_linker_links() {
  cd ${BUNDLE_DIR}
  OTOOL_L=$(otool -L $1)

  #### LINKED LIBS
  if echo "${OTOOL_L}" | grep -q /usr/local/
  then
    echo "${OTOOL_L}"
    error "$1 contains /usr/local/ string <-- Picked some homebrew libraries!"
  fi

  if echo "${OTOOL_L}"  | grep -q $QGIS_INSTALL_DIR
  then
    echo "${OTOOL_L}"
    error "$1 contains $QGIS_INSTALL_DIR string <-- forgot to change install_name for the linked library?"
  fi

  if echo "${OTOOL_L}"  | grep -q $STAGE_PATH
  then
    echo "${OTOOL_L}"
    echo "$1 contains $STAGE_PATH string <-- forgot to change install_name for the linked library?"
  fi

  if echo ${OTOOL_L} | grep -q $BUNDLE_DIR
  then
    echo "${OTOOL_L}"
    echo "$1 contains $BUNDLE_DIR string <-- forgot to change install_name for the linked library?"
  fi

  targets=(
    libz
    libssl
    libcrypto
    libpq
    libexpat
    libiconv
    libxml2
    libsqlite3
  )

  for i in ${targets[*]}
  do
      if echo "${OTOOL_L}" | grep -q /usr/lib/$i.dylib
      then
        echo "${OTOOL_L}"
        error "$1 contains /usr/lib/$i.dylib string -- we should be using our $i, not system!"
      fi
  done

  ######## RPATH
  OTOOL_RPATH=$(otool -l $1 | grep RPATH -A2)

  if echo "${OTOOL_RPATH}" | grep -q /usr/local/
  then
    echo "${OTOOL_RPATH}"
    error "$1 RPATH contains /usr/local/ string <-- forgot to delete/modify RPATH?"
  fi

  if echo "${OTOOL_RPATH}"  | grep -q $QGIS_INSTALL_DIR
  then
    echo "${OTOOL_RPATH}"
    error "$1 RPATH contains $QGIS_INSTALL_DIR string <-- forgot to delete/modify RPATH?"
  fi

  if echo "${OTOOL_RPATH}"  | grep -q $ROOT_OUT_PATH
  then
    echo "${OTOOL_RPATH}"
    echo "$1 RPATH contains $ROOT_OUT_PATH string <-- forgot to delete/modify RPATH?"
  fi

  if echo ${OTOOL_RPATH} | grep -q $BUNDLE_DIR
  then
    echo "${OTOOL_RPATH}"
    echo "$1 RPATH contains $BUNDLE_DIR string <-- forgot to delete/modify RPATH?"
  fi
}

run_final_check() {
  info "Running final check in the ${BUNDLE_DIR}"

  # libs
  info "Check libraries"
  cd ${BUNDLE_DIR}
  LIBS1=`find . -type f -name "*.so"`
  LIBS2=`find . -type f -name "*.dylib"`
  LIBS="$LIBS1 $LIBS2"
  for lib in $LIBS; do
    check_binary_linker_links $lib
  done

  info "Check binaries"
  # frameworks (Mach-O without binaries)
  LIBS=`find . -type f ! -name "*.*"`
  for lib in $LIBS; do
    attachmenttype=$(file ${STAGE_PATH}/bin/$lib | cut -d\  -f2 )
    if [[ $attachmenttype = "Mach-O" ]]; then
      check_binary_linker_links $lib
    fi
  done

  info "Check other files"
  # all other files
  if grep -rni $BUNDLE_DIR .
  then
    grep -rni $STAGE_PATH $STAGE_PATH
    error "Some scripts reference absolute BUNDLE_DIR dir $BUNDLE_DIR"
  fi
}

function run() {
  run_prepare_bundle_dir
  run_source_modules
  run_check
  run_bundle
  run_postbundle
  run_add_config_info
  run_final_check
  info "All done !"
}

run