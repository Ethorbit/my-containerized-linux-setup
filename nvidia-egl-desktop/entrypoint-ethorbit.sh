#!/bin/bash

# Send the Docker variables to files that will be sourced by our systemd services
printenv | sed 's|^|export |' > /etc/default/entrypoint
#sudo -u user printenv | sed 's|^|export |' > /etc/default/entrypoint
#
#cat >> /etc/default/entrypoint << EOL
#export ENABLE_BASIC_AUTH="${ENABLE_BASIC_AUTH}"
#export BASIC_AUTH_PASSWORD="${BASIC_AUTH_PASSWORD}"
#export PASSWD="${PASSWD}"
#EOL
#
cat > /etc/default/pulseaudio << EOL
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR}"
export XDG_CURRENT_DESKTOP="${XDG_CURRENT_DESKTOP}"
export XDG_SESSION_DESKTOP="${XDG_SESSION_DESKTOP}"
export XMODIFIERS="${XMODIFIERS}"
export DESKTOP_SESSION="${DESKTOP_SESSION}"
export PATH="${PATH}"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}"
export DISPLAY="${DISPLAY}"
export PULSE_SERVER="${PULSE_SERVER}"
EOL

cat > /etc/default/selkies-gstreamer << EOL
export LANGUAGE="${LANGUAGE}"
export LC_ALL="${LC_ALL}"
export LS_COLORS="${LS_COLORS}"
export XIM="${XIM}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR}"
export XDG_CURRENT_DESKTOP="${XDG_CURRENT_DESKTOP}"
export XDG_SESSION_DESKTOP="${XDG_SESSION_DESKTOP}"
export XMODIFIERS="${XMODIFIERS}"
export DESKTOP_SESSION="${DESKTOP_SESSION}"
export PATH="${PATH}"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}"
export LD_PRELOAD="${LD_PRELOAD}"
export SDL_JOYSTICK_DEVICE="${SDL_JOYSTICK_DEVICE}"
export PULSE_SERVER="${PULSE_SERVER}"
export WEBRTC_ENCODER="${WEBRTC_ENCODER}"
export WEBRTC_ENABLE_RESIZE="${WEBRTC_ENABLE_RESIZE}"
export VGL_REFRESHRATE="${VGL_REFRESHRATE}"
export VGL_DISPLAY="${VGL_DISPLAY}"
export NVIDIA_VISIBLE_DEVICES="${NVIDIA_VISIBLE_DEVICES}"
export NVIDIA_DRIVER_CAPABILITIES="${NVIDIA_DRIVER_CAPABILITIES}"
export CDEPTH="${CDEPTH}"
export DPI="${DPI}"
export SIZEW="${SIZEW}"
export SIZEH="${SIZEH}"
export DISPLAY="${DISPLAY}"
export NOVNC_ENABLE="${NOVNC_ENABLE}"
export NOVNC_VIEWPASS="${NOVNC_VIEWPASS}"
export NOVNC_VIEWONLY="${NOVNC_VIEWONLY}"
export TURN_HOST="${TURN_HOST}"
export TURN_PORT="${TURN_PORT}"
export TURN_PROTOCOL="${TURN_PROTOCOL}"
export TURN_TLS="${TURN_TLS}"
export TURN_SHARED_SECRET="${TURN_SHARED_SECRET}"
export TURN_USERNAME="${TURN_USERNAME}"
export TURN_PASSWORD="${TURN_PASSWORD}"
export ENV_NOVNC_ENABLE="${ENV_NOVNC_ENABLE}"
export GST_DEBUG="${GST_DEBUG}"
export ENABLE_BASIC_AUTH="${ENABLE_BASIC_AUTH}"
export BASIC_AUTH_PASSWORD="${BASIC_AUTH_PASSWORD}"
export PASSWD="${PASSWD}"
EOL

#printenv | sed 's|^|export |' > /etc/default/selkies-gstreamer
#sudo -u user printenv | sed 's|^|export |' >> /etc/default/selkies-gstreamer


# Finally, System init
exec /sbin/init --log-level=err "$@"
