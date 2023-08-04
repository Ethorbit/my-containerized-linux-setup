# docker or podman
TOOL := podman
# Important! If you're using a NVIDIA gpu, set to 1. You need nvidia-container-runtime and nvidia-smi.
NVIDIA := 1
# Directory that is mounted to container's /volume dir
STORAGE := /opt/distrobox


CHECK_NVIDIA_RUNTIME := $(shell command -v nvidia-container-runtime)
CHECK_NVIDIA_SMI := $(shell command -v nvidia-smi)
ifneq ($(NVIDIA),)
ifeq ($(CHECK_NVIDIA_RUNTIME),)
$(error You need nvidia-container-runtime)
endif

ifeq ($(CHECK_NVIDIA_SMI),)
$(error You need nvidia-smi)
else
ifeq ($(NVIDIA_VERSION),)
NVIDIA_VERSION := $(shell nvidia-smi --query-gpu=driver_version --format=csv,noheader)
endif
endif
endif

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

#define set_additional_flags
#$(eval ADDITIONAL_FLAGS := --additional-flags "$(1)")
#endef

define add_additional_flag
$(eval ADDITIONAL_FLAGS := $(ADDITIONAL_FLAGS) $(1))
endef

define add_volume_map
$(eval VOLUME_MAPS := --volume $(1) $(VOLUME_MAPS))
endef

define add_build_arg
$(eval BUILD_ARGS := --build-arg $(1) $(BUILD_ARGS))
endef

BINARY_DIR := $(HOME_DIR)/.local/bin
# $(eval BINARY_DIR := $(HOME_DIR)/.local/bin/$@.$(DISTRO))

define setup_build_args
	$(shell [ ! -z "$(NVIDIA)" ] && $(call add_build_arg, NVIDIA=$(NVIDIA)))
	$(shell [ ! -z "$(NVIDIA_VERSION)" ] && $(call add_build_arg, NVIDIA_VERSION=$(NVIDIA_VERSION)))
endef

define setup_additional_flags
	$(shell [ ! -z "$(NVIDIA)" ] &&\
		$(call add_additional_flag, --security-opt='label=disable') \
		$(call add_additional_flag, -e NVIDIA_VISIBLE_DEVICES=all) \
		$(call add_additional_flag, -e NVIDIA_DRIVER_CAPABILITIES=all))
endef

define setup_paths
$(eval STORAGE_PATH := $(STORAGE)/$@.$(DISTRO))
$(shell [ ! -d "$(STORAGE_PATH)" ] && sudo mkdir -p "$(STORAGE_PATH)" &&\
	 [ -z "$(SUDO)" ] && sudo chown "${USER}":"${USER}" "$(STORAGE_PATH)")
$(eval VOLUME_MAPS := --volume "$(STORAGE_PATH)":/volume $(VOLUME_MAPS))
endef

define make_container
	$(call setup_build_args)
	$(call setup_additional_flags)
	$(SUDO) $(TOOL) image build -t my-$@:$(DISTRO) $(BUILD_ARGS) --file "$@.$(DISTRO).Dockerfile" &&\
	distrobox-rm -f $(ROOT) $@ &&\
	distrobox-create --name $@ $(ROOT) --init --additional-flags "$(ADDITIONAL_FLAGS)" $(INIT_HOOKS) $(VOLUME_MAPS) --image my-$@:$(DISTRO) &&\
	mkdir -p "$(BINARY_DIR)"
endef

# Builds all the 'base' images
BASES_DIR := $(CURDIR)/bases
BASE_FILES := $(shell ls bases/*.Dockerfile)
base: $(BASE_FILES)
	$(call setup_build_args)
	for f in $(BASE_FILES); do \
	filename="$$(basename $$f .Dockerfile)" &&\
	IFS='.' read -r image tag <<< "$$filename" &&\
	$(SUDO) $(TOOL) build $(BUILD_ARGS) -t my-base:$${image}-$${tag} --file "$$f" || exit 1; done &&\
	touch $@
	$(eval BUILD_ARGS :=)

# For now desktop runs as root because no one has a solution for running Xorg with rootless Podman
.PHONY: desktop
desktop: base
	$(call set_root)
	$(call setup_paths)
	$(call make_container)
	distrobox-enter $(ROOT) $@ -- distrobox-export --bin /$@.sh

.PHONY: flatpak
flatpak: base
	$(call setup_paths)
	$(call make_container)
	distrobox-enter $(ROOT) $@ -- distrobox-export --bin /usr/bin/$@

.PHONY: snap
snap: base
	$(call setup_paths)
	$(call make_container)
	distrobox-enter $(ROOT) $@ -- sudo /install-$@s.sh &&\
	distrobox-enter $(ROOT) $@ -- distrobox-export --bin /usr/bin/$@ ||\
	distrobox-rm -f $(ROOT) $@ 2> /dev/null

.PHONY: games
games: base
	$(call setup_paths)
	$(call make_container)

.PHONY: clitools
clitools: base
	$(call setup_paths)
	$(call make_container)

.PHONY: virtualization
virtualization: base
	$(call setup_paths)
	$(call make_container)
