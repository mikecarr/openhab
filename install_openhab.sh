#!/bin/bash

VERSION=1.7.1
INSTALL_DIR=/opt/openhab
TMP_DIR=$INSTALL_DIR/temp
OPENHAB_BINARY_SITE=https://bintray.com/artifact/download/openhab/bin
HABMIN_BINARY_SITE=https://github.com/cdjackson/HABmin/archive/master.zip

BROKER_NAME=mosquitto-dev
BROKER_URL=tcp://localhost:1883

#Check if run as root
if [[ $EUID -ne 0 ]]; then
	echo "You must be root to do that! Please use sudo."
	exit 1
fi

# check if folder already exists, if it does back up conf files
if [ -d "$INSTALL_DIR" ]; then
  echo "folder exists, is this an upgrade?"
  
  sudo cp -r $INSTALL_DIR/configurations/items $TMP_DIR
  sudo cp -r $INSTALL_DIR/configurations/sitemaps $TMP_DIR

  rm -rf $INSTALL_DIR/*
else
  mkdir $INSTALL_DIR/
fi

# create tmp folder for addons, other
if [ ! -d "$TMP_DIR" ]; then
  mkdir $TMP_DIR
fi

apt-get update
apt-get upgrade

cd /opt/openhab

wget $OPENHAB_BINARY_SITE/distribution-$VERSION-runtime.zip
wget $OPENHAB_BINARY_SITE/distribution-$VERSION-addons.zip
wget $OPENHAB_BINARY_SITE/distribution-$VERSION-demo.zip
wget $HABMIN_BINARY_SITE

unzip -o distribution-$VERSION-runtime.zip
unzip -o distribution-$VERSION-demo.zip
unzip -o master.zip

mv distribution-$VERSION-addons.zip $TMP_DIR
rm distribution-$VERSION-runtime.zip
rm distribution-$VERSION-demo.zip
rm master.zip

# setup habmin
mkdir webapps/habmin
mv HABmin-master/* webapps/habmin/
rm -rf HABmin-master
cd webapps/habmin
mv addons/* ../../addons/
rm -rf addons

cd $TMP_DIR
unzip -o distribution-$VERSION-addons.zip
cp *mqtt-* $INSTALL_DIR/addons

cd $INSTALL_DIR
cp configurations/openhab_default.cfg configurations/openhab.cfg

sudo sed -i "s%^#mqtt.<broker>.url.*%mqtt:$BROKER_NAME.url=$BROKER_URL%" configurations/openhab.cfg
sudo sed -i "s%^#mqtt.<broker>.retain.*%mqtt:$BROKER_NAME.retain=true%" configurations/openhab.cfg

echo "Done!"

chmod +x start.sh
