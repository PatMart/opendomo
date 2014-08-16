#!/bin/sh

# Variables

SCRIPTSDIR="scripts"
. $SCRIPTSDIR/sdk_variables.sh
USER=`users | cut -f1 -d" "`

# Check
if ! test -x "/usr/bin/qemu-img"; then
	echo "ERROR: You need install qemu first"
	exit 1
fi

if ! test -x "/usr/bin/extlinux" && ! test -x "/usr/sbin/extlinux";
then
	echo "ERROR: You need install extlinux first"
	exit 1
fi

# Copy ISOFILES
cp -r $ISOFILESDIR/* $TARGETDIR/

# Exporting to RAW image
echo "INFO: Export opendomo to RAW image ..."
rm $EXPORTDIR/$IMGNAME.img 2>/dev/null

# Creating image
qemu-img create -f raw $EXPORTDIR/$IMGNAME.img 2G >/dev/null

# Creating RAW image
losetup -f $EXPORTDIR/$IMGNAME.img
LOOPDEV=`losetup -a | grep -m1 "$EXPORTDIR/$IMGNAME.img" | cut -f1 -d: | tail -n1`

if
mkfs.vfat $LOOPDEV >/dev/null 2>/dev/null
then
	mount $EXPORTDIR/$IMGNAME.img $MOUNTDIR
	cp -r $TARGETDIR/* $MOUNTDIR/ 2>/dev/null

	# Installing bootloader
	extlinux -i $MOUNTDIR >/dev/null 2>/dev/null

	# Wait for unmount
	sleep 5
	umount $MOUNTDIR

	# Deleting all opendomo sdk loops
	for lo in `losetup -a | grep -m1 "$EXPORTDIR/$IMGNAME.img" | cut -f1 -d: | tail -n1`; do
		losetup -d $lo 2>/dev/null
	done
fi

# Convert raw to vmdk
qemu-img convert -O vmdk $EXPORTDIR/$IMGNAME.img $EXPORTDIR/$IMGNAME.vmdk >/dev/null

# Fix image perms
chown $USER $EXPORTDIR/$IMGNAME.img 2>/dev/null
chown $USER $EXPORTDIR/$IMGNAME.vmdk 2>/dev/null
