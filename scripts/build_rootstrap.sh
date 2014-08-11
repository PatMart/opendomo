#!/bin/sh

# Variables

SCRIPTSDIR="scripts"
. $SCRIPTSDIR/sdk_variables.sh

# Check and clean
if ! test -f $INITRDIMG; then
        echo "ERROR: initrd image don't exist"
        exit 1
fi
if test -d $ROOTSTRAPDIR; then
	echo "WARN: rootstrap is already created"
	exit 0
fi

# Copy initrd to create rootstrap
cp -rp $INITRDDIR $ROOTSTRAPDIR

# Update rootstrap apt sources
rm -fr $ROOTSTRAPDIR/etc/ resolv.conf
cp /etc/resolv.conf $ROOTSTRAPDIR/etc/ 
$CHROOT "$ROOTSTRAPDIR" /bin/bash -c "apt-get update"

# Installing rootstrap packages
$CHROOT "$ROOTSTRAPDIR" /bin/bash -c "LC_ALL=C LANGUAGE=C LANG=C DEBIAN_FRONTEND=noninteractive apt-get --force-yes -yq install $ROOTSTRAPPKG"
$CHROOT "$ROOTSTRAPDIR" /bin/bash -c "LC_ALL=C LANGUAGE=C LANG=C dpkg-reconfigure --frontend=noninteractive debconf"
$CHROOT "$ROOTSTRAPDIR" /bin/bash -c "apt-get clean"
