# Get root directory (where this Makefile is)
ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
UNAME    := $(shell uname)

NIX_CMD  := $(shell which nix)
HM_CMD   := $(shell which home-manager)

ifeq ($(UNAME), Darwin)
	REBUILD_CMD := $(shell which darwin-rebuild)
	HOSTNAME    := $(shell scutil --get LocalHostName)
else ifeq ($(UNAME), Linux)
	REBUILD_CMD := $(shell which nixos-rebuild)
	HOSTNAME    := $(shell hostname)
else
	$(error unknown OS $(UNAME))
endif

USER     ?= ""
HM_FLAKE ?= ".\#$(USER)@$(HOSTNAME)"
FLAKE    ?= ".\#$(HOSTNAME)"

.PHONY: build
build: clean
	$(REBUILD_CMD) build --flake $(FLAKE)

.PHONY: switch
switch: clean
ifeq ($(UNAME), Darwin)
	$(REBUILD_CMD) switch --flake $(FLAKE)
else ifeq ($(UNAME), Linux)
	sudo $(REBUILD_CMD) switch --flake $(FLAKE)
endif

.PHONY: hmbuild
hmbuild: clean
	$(HM_CMD) build --flake $(HM_FLAKE)

.PHONY: hmswitch
hmswitch: clean
	$(HM_CMD) switch --flake $(HM_FLAKE)

.PHONY: hmnews
hmnews: clean
	$(HM_CMD) news --flake $(HM_FLAKE)

.PHONY: clean
clean:
	@rm -rf $(ROOT_DIR)/result

.PHONY: check
check:
	@echo "User:                $(USER)"
	@echo "Hostname:            $(HOSTNAME)"
	@echo "Home Manager Flake:  $(HM_FLAKE)"
	@echo "Flake:               $(FLAKE)"
	@echo "Rebuild command:     $(REBUILD_CMD)"

.PHONY: lint
lint:
	$(NIX_CMD) run nixpkgs#statix -- check

.PHONY: fix
fix:
	$(NIX_CMD) run nixpkgs#statix -- fix

.PHONY: update
update:
	$(NIX_CMD) flake update --commit-lock-file --commit-lockfile-summary "chore(deps): update flake.lock"
