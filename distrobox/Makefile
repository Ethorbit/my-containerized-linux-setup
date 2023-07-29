TOOL := podman
NVIDIA := --nvidia  # Remove if you're not using a NVIDIA gpu for containers
STORAGE := /opt/distrobox
EXPORT := /opt/distrobox-exported

CHECK_STORAGE := $(shell [ -d $(STORAGE) ] && echo 1)
ifeq ($(CHECK_STORAGE),)
$(error $(STORAGE) does not exist.)
endif

CHECK_EXPORT := $(shell [ -d $(EXPORT) ] && echo 1)
ifeq ($(CHECK_EXPORT),)
$(error $(EXPORT) does not exist.)
endif

.PHONY: init desktop apps games clitools virtualization

ifeq ($(DISTRO),)
$(error DISTRO variable is not set.)
endif

define setup_paths
$(eval STORAGE_PATH := $(STORAGE)/$(MAKECMDGOALS).$(DISTRO))
$(eval EXPORT_PATH := $(EXPORT))
$(shell [ ! -d "$(STORAGE_PATH)" ] && sudo mkdir -p "$(STORAGE_PATH)")
# $(shell [ ! -d "$(EXPORT_PATH)" ] && sudo mkdir -p "$(EXPORT_PATH)")
$(shell [ ! -d "$(EXPORT_PATH)/etc/systemd/system" ] && sudo mkdir -p "$(EXPORT_PATH)/etc/systemd/system")
endef

define desktop_service

endef

desktop:
	$(call setup_paths)
	sudo $(TOOL) image build -t my-$@:$(DISTRO) --file "$@.$(DISTRO).Dockerfile"
	distrobox-rm -f --root $@
	distrobox-create --name $@ --root --init $(NVIDIA) --volume "$(STORAGE_PATH)":/volume --image my-$@:$(DISTRO)
	distrobox-enter --root $@ -- distrobox-export --root --bin /desktop.sh --sudo
	[ ! -f "$(EXPORT)/etc/systemd/system/my-desktop.service" ] &&\
		sudo /bin/bash -c 'echo "$(desktop_service)" > "$(EXPORT)/etc/systemd/system/my-desktop.service" && systemctl daemon-reload'
	@echo "Done. System service: my-desktop.service generated."

apps:
	$(call setup_paths)

games:
	$(call setup_paths)

clitools:
	$(call setup_paths)

virtualization:
	$(call setup_paths)
