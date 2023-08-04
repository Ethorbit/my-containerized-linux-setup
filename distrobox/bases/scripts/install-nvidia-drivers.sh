#!/bin/bash
NVIDIA_VERSION="$1"
ARCH=$(uname -m)
curl -fsSl -o nvidia.run \
	"https://download.nvidia.com/XFree86/Linux-${ARCH}/${NVIDIA_VERSION}/NVIDIA-Linux-${ARCH}-${NVIDIA_VERSION}.run" &&\
	TERM=xterm sh nvidia.run -s --no-kernel-modules --no-opengl-files &&\
	rm -f nvidia.run
