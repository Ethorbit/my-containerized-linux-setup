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

HOME_DIR := $(shell echo $$HOME)

define set_root
$(eval ROOT := --root)
$(eval SUDO := sudo)
$(eval SUDOFLAG := --sudo)
endef

define set_init_hook
$(eval INIT_HOOKS := --init-hooks "$(1)")
endef

BINARY_DIR := $(HOME_DIR)/.local/bin
# $(eval BINARY_DIR := $(HOME_DIR)/.local/bin/$@.$(DISTRO))

define setup_paths
$(eval STORAGE_PATH := $(STORAGE)/$@.$(DISTRO))
$(shell [ ! -d "$(STORAGE_PATH)" ] && sudo mkdir -p "$(STORAGE_PATH)")
$(eval VOLUME_MAPS := --volume "$(STORAGE_PATH)":/volume)
endef

define make_container
$(call setup_paths)
	$(SUDO) $(TOOL) image build -t my-$@:$(DISTRO) --file "$@.$(DISTRO).Dockerfile" &&\
	distrobox-rm -f $(ROOT) $@ &&\
	distrobox-create --name $@ $(ROOT) --init $(NVIDIA) $(INIT_HOOKS) $(VOLUME_MAPS) --image my-$@:$(DISTRO) &&\
	mkdir -p "$(BINARY_DIR)"
endef

.PHONY: desktop
desktop:
	$(call set_root)
	$(call make_container)
	distrobox-enter $(ROOT) $@ -- distrobox-export --bin /$@.$(DISTRO).sh --sudo

.PHONY: apps
apps:
	$(call set_init_hook,/$@.$(DISTRO).sh)
	$(call make_container)
	distrobox-enter $(ROOT) $@ -- distrobox-export --bin /usr/bin/flatpak

.PHONY: games
games:
	$(call make_container)

.PHONY: clitools
clitools:
	$(call make_container)

.PHONY: virtualization
virtualization:
	$(call make_container)
