# my-containerized-linux-setup
Personal OCI container images created to containerize my entire workflow because why not?

## Why I do this?
I like the idea of isolating groups of tasks from my daily workflow to avoid the risks and problems that come with running everything on a single instance; problems can range from dependency issues and conflicts to security and privacy concerns.

The problem with just using traditional virtual machines is that they are heavy on resources and cannot have the GPU shared without spendy vGPU licensing. This project solves virtual machine limitations by instead using free and open-source OCI containerization to share the host's resources between isolated processes. The desktops are streamed over WebRTC, providing the full graphical performance; this is scalable, limited only by the system's available resources.

## Notes
* Some automatated variables are needed, which are generated as an .env file by the generate-env.sh bash script.
* Desktops are configured to use the [Sysbox container runtime](https://github.com/nestybox/sysbox) which needs to be installed. Sysbox allows containers to be more "VM-Like" without compromising on performance, allowing them to run things that containers don't typically run, such as Systemd and Docker.
* Desktops are also configured to use [LXCFS](https://github.com/lxc/lxcfs) which needs to be installed and enabled. LXCFS allows resource isolation so that containers can only see the resources they're allowed to use, rather than all the resources, which can improve performance when containers are restricted to their very own CPU cores.
* Selkies-GStreamer doesn't work on Firefox at the moment, so a chromium browser is needed to connect.
