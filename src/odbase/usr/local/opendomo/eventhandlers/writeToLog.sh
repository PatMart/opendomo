#!/bin/sh
#desc:Write to log
#package:odbase

DATE=`date +"%Y-%m-%d.%H:%M:%S.%N"`
echo "$DATE	$3	$1 $2	$4 " >> /var/opendomo/log/events.log
chmod 0664 /var/opendomo/log/events.log
