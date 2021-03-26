#!/bin/bash
mkdir -p /usr/local/var/lib
chmod 777 /usr/local/var/lib
mkdir /usr/local/var/lib/pulse | true
chown pulse:pulse /usr/local/var/lib/pulse
mkdir /usr/local/var/run/pulse | true
chown pulse:pulse /usr/local/var/run/pulse

exit 0
