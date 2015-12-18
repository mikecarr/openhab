#!/bin/sh

VERSION=1.5.1

apt-get update
apt-get upgrade

mkdir /opt/openhab

cd /opt/openhab

wget https://github.com/openhab/openhab/releases/download/v$VERSION/distribution-$VERSION-runtime.zip
wget https://github.com/openhab/openhab/releases/download/v$VERSION/distribution-$VERSION-addons.zip
wget https://github.com/openhab/openhab/releases/download/v$VERSION/distribution-$VERSION-demo-configuration.zip

unzip distribution-$VERSION-runtime.zip
unzip distribution-$VERSION-demo-configuration.zip

rm distribution-$VERSION-runtime.zip
rm distribution-$VERSION-demo-configuration.zip

cp configurations/openhab_default.cfg configurations/openhab.cfg



chmod +x start.sh
