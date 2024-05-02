#!/bin/bash
source /etc/default/pulseaudio

bash -c "until [ -S \"/tmp/.X11-unix/X${DISPLAY/:/}\" ]; do sleep 1; done; sudo /usr/bin/pulseaudio -k >/dev/null 2>&1 || sudo /usr/bin/pulseaudio --system --verbose --log-target=stderr --realtime=true --disallow-exit -L 'module-native-protocol-tcp auth-ip-acl=127.0.0.0/8 port=4713 auth-anonymous=1'"
