#!/bin/bash

# Add files that should persist through volume storage
/persist.sh \
	/etc/X11 \
	/etc/lightdm \
	/etc/i3 \
	/etc/polybar \
	/etc/pulse

# Start the desktop
systemctl unmask dbus.service
systemctl start dbus.service
while [ -z $(pidof lightdm) ]; do 
	lightdm
	sleep 0.1
done
