#!/usr/bin/env bash

rm -rf ramdisk ldid
mkdir ramdisk
wget https://github.com/ProcursusTeam/ldid/releases/download/v2.1.5-procursus6/ldid_macosx_x86_64 -O ldid
chmod +x ldid
cp ../palera1n-boot-checkra1n/other/rootfs/* ramdisk -r

# copy loader & rootfs

cd ramdisk/jbin
rm -rf loader.app
curl -LO https://static.palera.in/deps/loader.zip
unzip loader.zip -d .
unzip palera1n.ipa -d .
mv Payload/palera1nLoader.app loader.app
rm -rf palera1n.zip loader.zip palera1n.ipa Payload

curl -L https://static.palera.in/deps/rootfs.zip -o rfs.zip
unzip rfs.zip -d .
unzip rootfs.zip -d .
rm rfs.zip rootfs.zip

cd ../..

# copy binpack

mkdir -p ramdisk/jbin/binpack
curl -L https://static.palera.in/binpack.tar -o ramdisk/jbin/binpack/binpack.tar
tar -xvf ramdisk/jbin/binpack/binpack.tar -C ramdisk/jbin/binpack/
rm ramdisk/jbin/binpack/binpack.tar

# prepare jbinit
./ldid -s ramdisk/jbin/launchd ramdisk/jbin/jbloader ramdisk/jbin/jb.dylib
chmod +rwx ramdisk/jbin/launchd ramdisk/jbin/jbloader ramdisk/jbin/post.sh

hdiutil create -size 200m -layout NONE -format UDRW -srcfolder ./ramdisk -fs HFS+ ./ramdisk.dmg
