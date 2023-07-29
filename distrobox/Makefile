# Docker or Podman
TOOL := podman
# Set to NVIDIA := if you're not using a NVIDIA gpu for containers
NVIDIA := --nvidia
# Directory that is mounted to container's /volume dir
STORAGE := /opt/distrobox

CHECK_STORAGE := $(shell [ -d $(STORAGE) ] && echo 1)
ifeq ($(CHECK_STORAGE),)
$(error $(STORAGE) does not exist.)
endif

ifeq ($(DISTRO),)
$(error DISTRO variable is not set.)
endif

define setup_paths
$(eval STORAGE_PATH := $(STORAGE)/$(MAKECMDGOALS).$(DISTRO))
$(shell [ ! -d "$(STORAGE_PATH)" ] && sudo mkdir -p "$(STORAGE_PATH)")
endef

desktop:
	$(call setup_paths)
	sudo $(TOOL) image build -t my-$@:$(DISTRO) --file "$@.$(DISTRO).Dockerfile"
	distrobox-rm -f --root $@
	distrobox-create --name $@ --root --init $(NVIDIA) --volume "$(STORAGE_PATH)":/volume --image my-$@:$(DISTRO)
	distrobox-enter --root $@ -- distrobox-export --bin /start.sh --sudo

.PHONY: apps
apps:
	$(call setup_paths)

.PHONY: games
games:
	$(call setup_paths)

.PHONY: clitools
clitools:
	$(call setup_paths)

.PHONY: virtualization
virtualization:
	$(call setup_paths)
