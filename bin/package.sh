#!/bin/bash

# directory used for deployment
export DEPLOY_DIR=lambda

# make deployment directory and add lambda handler
mkdir -p $DEPLOY_DIR

# copy libs
# cp -P ${PREFIX}/lib/*.so* $DEPLOY_DIR/lib/
# cp -P ${PREFIX}/lib64/libjpeg*.so* $DEPLOY_DIR/lib/
cp -P -r /var/task/* $DEPLOY_DIR


strip $DEPLOY_DIR/* || true

# copy GDAL_DATA files over
# mkdir -p $DEPLOY_DIR/share
# rsync -ax $PREFIX/share/gdal $DEPLOY_DIR/share/
# rsync -ax $PREFIX/share/proj $DEPLOY_DIR/share/

# zip up deploy package
cd $DEPLOY_DIR
zip --symlinks -ruq ../lambda-deploy.zip ./
