#!/bin/bash

function check_python_packages() {
  env_var_exists VERSION_python_packages
  env_var_exists DEPS_PYTHON_SITE_PACKAGES_DIR
  env_var_exists BUNDLE_PYTHON_SITE_PACKAGES_DIR
}

function bundle_python_packages() {
   try rsync -av $DEPS_PYTHON_SITE_PACKAGES_DIR/ $BUNDLE_PYTHON_SITE_PACKAGES_DIR/ --exclude __pycache__
}

function postbundle_python_packages() {
 install_name_delete_rpath /opt/QGIS/qgis-deps-0.3.0/stage/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/Qsci.so

 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/QtPrintSupport.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/QtPositioning.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/QtXml.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/QtHelp.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/QtQuickWidgets.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/QtMultimediaWidgets.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/QtNfc.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/QtQuick.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/QtNetwork.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/_QOpenGLFunctions_4_1_Core.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/QtWebChannel.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/_QOpenGLFunctions_2_0.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/QtMultimedia.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/_QOpenGLFunctions_2_1.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/Qsci.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/QtWidgets.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/QtBluetooth.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/QtGui.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/QtDBus.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/QtSql.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/QtTest.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/QtLocation.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/QtDesigner.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/QtQml.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/QtOpenGL.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/pylupdate.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/QtCore.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/QtRemoteObjects.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/QtSensors.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/QtWebSockets.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/QtXmlPatterns.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/QtMacExtras.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/QtSerialPort.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/QtSvg.so
 install_name_delete_rpath /opt/Qt/5.14.1/clang_64/lib $BUNDLE_CONTENTS_DIR/Resources/python/site-packages/PyQt5/pyrcc.so
}

function add_config_info_python_packages() {
    :
}
