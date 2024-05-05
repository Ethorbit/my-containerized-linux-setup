# my-containerized-linux-setup
Containers that make up my entire workflow

## Why I do this
I like the idea of isolating groups of tasks from my daily workflow to avoid the risks and problems that come with running everything on a single instance; problems can range from dependency issues and conflicts to security and privacy concerns.

The problem with just using traditional virtual machines is that they are heavy on resources and cannot have the GPU shared without spendy vGPU licensing. This project solves virtual machine limitations by instead using free and open-source OCI containerization to share the host's resources between isolated processes. The desktops are streamed over WebRTC, providing the full graphical performance; this is scalable, limited only by the system's available resources.

## Usage
* First, necessesities need to be up.
`docker compose --profile default up -d`

* Next, a workflow task is started.
`docker compose --profile development up --build -d`

* Services are assigned their own subdomains, so in this case I will use my development desktop by navigating to: `https://desktop.development.linux`

## Notes
* Some automatated variables are needed, which are generated as an .env file by the generate-env.sh bash script.
* Desktops are configured to use the [Sysbox container runtime](https://github.com/nestybox/sysbox) which needs to be installed. Sysbox allows containers to be more "VM-Like" without compromising on performance, allowing them to run things that containers don't typically run, such as Systemd and Docker.

Some Systemd services are really stubborn in a Sysbox environment and will refuse to work. I've found it's usually the 'Protect' properties that cause a service to break. The only fix I know of currently is to override the broken services and remove the problematic properties.

* Desktops are also configured to use [LXCFS](https://github.com/lxc/lxcfs) which needs to be installed and enabled. LXCFS allows resource isolation so that containers can only see the resources they're allowed to use, rather than all the resources, which can improve performance when containers are restricted to their very own CPU cores.
* `cpuset` is used on services which may spit out an error if you have less than 24 CPU threads. Manual intervention will be needed to change or remove these.
* Selkies-GStreamer doesn't work on Firefox at the moment, so a Chromium browser is needed to connect.
