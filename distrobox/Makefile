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

define set_additional_flags
$(eval ADDITIONAL_FLAGS := --additional-flags "$(1)")
endef

define add_volume_map
$(eval VOLUME_MAPS := --volume $(1) $(VOLUME_MAPS))
endef

BINARY_DIR := $(HOME_DIR)/.local/bin
# $(eval BINARY_DIR := $(HOME_DIR)/.local/bin/$@.$(DISTRO))

define setup_paths
$(eval STORAGE_PATH := $(STORAGE)/$@.$(DISTRO))
$(shell [ ! -d "$(STORAGE_PATH)" ] && sudo mkdir -p "$(STORAGE_PATH)" &&\
	 [ -z "$(SUDO)" ] && sudo chown "${USER}":"${USER}" "$(STORAGE_PATH)")
$(eval VOLUME_MAPS := --volume "$(STORAGE_PATH)":/volume $(VOLUME_MAPS))
endef

define make_container
	$(SUDO) $(TOOL) image build -t my-$@:$(DISTRO) --file "$@.$(DISTRO).Dockerfile" &&\
	distrobox-rm -f $(ROOT) $@ &&\
	distrobox-create --name $@ $(ROOT) --init $(ADDITIONAL_FLAGS) $(NVIDIA) $(INIT_HOOKS) $(VOLUME_MAPS) --image my-$@:$(DISTRO) &&\
	mkdir -p "$(BINARY_DIR)"
endef

# For now desktop runs as root because no one has a solution for running Xorg with rootless Podman
.PHONY: desktop
desktop:
	$(call set_root)
	$(call setup_paths)
	$(call make_container)
	distrobox-enter $(ROOT) $@ -- distrobox-export --bin /$@.sh

.PHONY: #apps
apps:
	$(call setup_paths)
	$(call make_container)
	distrobox-enter $(ROOT) $@ -- distrobox-export --bin /usr/bin/flatpak

.PHONY: games
games:
	$(call setup_paths)
	$(call make_container)

.PHONY: clitools
clitools:
	$(call setup_paths)
	$(call make_container)

.PHONY: virtualization
virtualization:
	$(call setup_paths)
	$(call make_container)
