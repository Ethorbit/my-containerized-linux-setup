#!/usr/bin/env bash
cat > .env << EOL
HOST_TIMEZONE=$(cat /etc/timezone)
# If this IP is incorrect, replace it in the generate-env.sh script.
HOST_LOCAL_IPV4=$(ip route get 1 | sed -n 's/^.*src \([0-9.]*\) .*$/\1/p')
TURN_SECRET=$(openssl rand -base64 64 | tr -d '\n')
KERNEL_VERSION=$(uname -r)
EOL

[ -f .custom.env ] && cat .custom.env >> .env || cat .custom.env.template >> .env
