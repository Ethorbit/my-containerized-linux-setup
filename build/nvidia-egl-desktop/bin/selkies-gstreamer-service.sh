#!/bin/bash
source /etc/default/selkies-gstreamer

bash -c "if [ ! $(echo ${ENV_NOVNC_ENABLE} | tr '[:upper:]' '[:lower:]') ]; then /etc/selkies-gstreamer-entrypoint.sh; else sleep infinity; fi"
