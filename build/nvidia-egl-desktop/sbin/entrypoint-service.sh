#!/bin/bash -e

source /etc/default/entrypoint
export XDG_RUNTIME_DIR=/run/user/$(id -u user)

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

trap "echo TRAPed signal" HUP INT QUIT TERM

# Create and modify permissions of XDG_RUNTIME_DIR
sudo -u user mkdir -pm700 /tmp/runtime-user
sudo chown user:user /tmp/runtime-user
sudo -u user chmod 700 /tmp/runtime-user
# Make user directory owned by the user in case it is not
sudo chown user:user /home/user || sudo chown user:user /home/user/* || { echo "Failed to change user directory permissions. There may be permission issues."; }
# Change operating system password to environment variable
echo "user:$PASSWD" | sudo chpasswd
# Remove directories to make sure the desktop environment starts
sudo rm -rf /tmp/.X* ~/.cache
# Change time zone from environment variable
sudo ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime && echo "$TZ" | sudo tee /etc/timezone > /dev/null

# Start DBus without systemd
#sudo /etc/init.d/dbus start

# Default display is :0 across the container
export DISPLAY=":0"
# Run Xvfb server with required extensions
/usr/bin/Xvfb "${DISPLAY}" -ac -screen "0" "8192x4096x${CDEPTH}" -dpi "${DPI}" +extension "COMPOSITE" +extension "DAMAGE" +extension "GLX" +extension "RANDR" +extension "RENDER" +extension "MIT-SHM" +extension "XFIXES" +extension "XTEST" +iglx +render -nolisten "tcp" -noreset -shmem &

# Wait for X11 to start
echo "Waiting for X socket"
until [ -S "/tmp/.X11-unix/X${DISPLAY/:/}" ]; do sleep 1; done
echo "X socket is ready"

# Resize the screen to the provided size
bash -c ". /opt/gstreamer/gst-env && /usr/local/bin/selkies-gstreamer-resize ${SIZEW}x${SIZEH}"

# Run the x11vnc + noVNC fallback web interface if enabled
if [ "${NOVNC_ENABLE,,}" = "true" ]; then
  if [ -n "$NOVNC_VIEWPASS" ]; then export NOVNC_VIEWONLY="-viewpasswd ${NOVNC_VIEWPASS}"; else unset NOVNC_VIEWONLY; fi
  /usr/local/bin/x11vnc -display "${DISPLAY}" -passwd "${BASIC_AUTH_PASSWORD:-$PASSWD}" -shared -forever -repeat -xkb -snapfb -threads -xrandr "resize" -rfbport 5900 ${NOVNC_VIEWONLY} &
  /opt/noVNC/utils/novnc_proxy --vnc localhost:5900 --listen 8080 --heartbeat 10 &
fi

# Use VirtualGL to run the KDE desktop environment with OpenGL if the GPU is available, otherwise use OpenGL with llvmpipe
if [ -n "$(nvidia-smi --query-gpu=uuid --format=csv | sed -n 2p)" ]; then
  export VGL_REFRESHRATE="${REFRESH}"
  sudo HOME=/home/user -Eu user /usr/bin/vglrun -d "${VGL_DISPLAY:-egl}" +wm /usr/bin/dbus-launch "${XSESSION_START_COMMAND:-/usr/bin/startplasma-x11}" &
else
  sudo HOME=/home/user -Eu user /usr/bin/dbus-launch "${XSESSION_START_COMMAND:-/usr/bin/startplasma-x11}" &
fi

# Start Fcitx input method framework
/usr/bin/fcitx &

sleep inf
