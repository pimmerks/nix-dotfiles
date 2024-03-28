# Get root directory (where this Makefile is)
ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
NIX_CMD  := $(shell which nix)
HM_CMD   := $(shell which home-manager)

USER     ?= ""
HOSTNAME ?= $(shell scutil --get LocalHostName)
FLAKE    ?= ".\#$(USER)@$(HOSTNAME)"

.PHONY: hmbuild
hmbuild: clean
	home-manager build --flake $(FLAKE)

.PHONY: hmswitch
hmswitch: clean
	home-manager switch --flake $(FLAKE)

.PHONY: clean
clean:
	@rm -rf $(ROOT_DIR)/result

.PHONY: check
check:
	@echo "User:      $(USER)"
	@echo "Hostname:  $(HOSTNAME)"
	@echo "Flake:     $(FLAKE)"

.PHONY: lint
lint:
	$(NIX_CMD) run nixpkgs#statix -- check

.PHONY: fix
fix:
	$(NIX_CMD) run nixpkgs#statix -- fix

