#!/bin/bash

DESC_freexl="Library to extract data from Excel .xls files"

# version of your package
VERSION_freexl=1.0.5
LINK_freexl=libfreexl.1.dylib

# dependencies of this recipe
DEPS_freexl=()

# url of the package
URL_freexl=https://www.gaia-gis.it/gaia-sins/freexl-sources/freexl-${VERSION_freexl}.tar.gz

# md5 of the package
MD5_freexl=3ed2a0486f03318820b25f0ccae5e14d

# default build path
BUILD_freexl=$BUILD_PATH/freexl/$(get_directory $URL_freexl)

# default recipe path
RECIPE_freexl=$RECIPES_PATH/freexl

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_freexl() {
  cd $BUILD_freexl

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_freexl() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_freexl -nt $BUILD_freexl/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_freexl() {
  try rsync -a $BUILD_freexl/ $BUILD_PATH/freexl/build-$ARCH/
  try cd $BUILD_PATH/freexl/build-$ARCH
  push_env

  try ${CONFIGURE} --disable-debug

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_freexl() {
  verify_binary lib/$LINK_freexl
}

# function to append information to config file
function add_config_info_freexl() {
  append_to_config_file "# freexl-${VERSION_freexl}: ${DESC_freexl}"
  append_to_config_file "export VERSION_freexl=${VERSION_freexl}"
  append_to_config_file "export LINK_freexl=${LINK_freexl}"
}
