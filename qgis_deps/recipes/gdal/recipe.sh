#!/bin/bash

DESC_gdal="Geospatial Data Abstraction Library"

# version of your package
# keep in SYNC with python_gdal receipt
VERSION_gdal=3.0.4

LINK_gdal=libgdal.26.dylib

# dependencies of this recipe
DEPS_gdal=(geos proj libgeotiff libxml2 xerces xz zstd libtiff netcdf hdf5 postgres jpeg png sqlite)

LINK_libgdal_version=26

# url of the package
URL_gdal=https://github.com/OSGeo/gdal/releases/download/v${VERSION_gdal}/gdal-${VERSION_gdal}.tar.gz

# md5 of the package
MD5_gdal=c6bbb5caca06e96bd97a32918e0aa9aa

# default build path
BUILD_gdal=$BUILD_PATH/gdal/$(get_directory $URL_gdal)

# default recipe path
RECIPE_gdal=$RECIPES_PATH/gdal

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_gdal() {
  cd $BUILD_gdal

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_gdal() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_gdal -nt $BUILD_gdal/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_gdal() {
  try rsync -a $BUILD_gdal/ $BUILD_PATH/gdal/build-$ARCH/
  try cd $BUILD_PATH/gdal/build-$ARCH
  push_env


  WITH_GDAL_DRIVERS=
  for i in xerces liblzma zstd libtiff geotiff jpeg hdf5 netcdf pg png spatialite sqlite3
  do
    WITH_GDAL_DRIVERS="$WITH_GDAL_DRIVERS --with-$i=$STAGE_DIR"
  done

  WITHOUT_GDAL_DRIVERS=
  for i in ecw grass libgrass cfitsio pcraster \
           dds gta gif ogdi fme sosi mongocxx \
           mongocxxv3 hdf4 kea jasper openjpeg fgdb \
           kakadu mrsid jp2mrsid mrsid_lidar \
           msg oci mysql ingres expat libkml odbc \
           dods-root rasterlite2
  do
    WITHOUT_GDAL_DRIVERS="$WITHOUT_GDAL_DRIVERS --without-$i"
  done

  try ${CONFIGURE} \
    --disable-debug \
    ${WITH_GDAL_DRIVERS} \
    ${WITHOUT_GDAL_DRIVERS}

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_gdal() {
  verify_binary lib/$LINK_gdal
  verify_binary bin/gdalmanage
}

# function to append information to config file
function add_config_info_gdal() {
  append_to_config_file "# gdal-${VERSION_gdal}: ${DESC_gdal}"
  append_to_config_file "export VERSION_gdal=${VERSION_gdal}"
  append_to_config_file "export LINK_gdal=${LINK_gdal}"
}