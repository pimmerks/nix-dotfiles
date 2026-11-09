# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A single Nix flake managing both NixOS (Linux) and nix-darwin (macOS) systems, plus
Home Manager configs, custom packages, and dotfiles. One repo, multiple hosts and
platforms (`x86_64-linux`, `aarch64-darwin`).

## Commands

All workflows go through the `Makefile`, which auto-detects the OS and current hostname
to pick the right rebuild command and flake target:

```shell
make build      # nixos-rebuild/darwin-rebuild build --flake .#<hostname>
make switch     # sudo rebuild switch --flake .#<hostname>
make check      # print resolved USER/HOSTNAME/flake targets (debug the Makefile)

make hmbuild    # home-manager build --flake .#<user>@<hostname>
make hmswitch   # home-manager switch --flake .#<user>@<hostname>
make hmnews     # home-manager news

make lint       # statix check
make fix        # statix fix
make update     # nix flake update + commit lock file

nix fmt         # format with alejandra (the flake's formatter)
```

`make` targets accept overrides: `make switch FLAKE=.#lin0` or `make hmswitch USER=pimmer`.
`HOSTNAME` comes from `scutil --get LocalHostName` (Darwin) or `hostname` (Linux), so on a
machine whose hostname doesn't match a config key you **must** pass `FLAKE`/`HM_FLAKE` explicitly.

Enter the dev shell (provides `deadnix`, `alejandra`, `statix`, `nh`, `home-manager`, etc.)
with `nix develop`.

## Architecture

The flake (`flake.nix`) is the single entry point and wires everything together. It defines
three kinds of outputs, each assembled from a list of module files:

- **`nixosConfigurations`** — full system configs (e.g. `lin0`).
- **`darwinConfigurations`** — full macOS system configs (e.g. `AA2134-Pims-MBP`).
- **`homeConfigurations`** — per-user Home Manager configs, keyed `<user>@<hostname>`.

On macOS the system (darwin) and user (Home Manager) layers are switched **separately**
(`make switch` then `make hmswitch`). On NixOS, Home Manager can be wired into the system
config, but here `homeConfigurations` is also defined standalone.

### Directory roles

- **`hosts/<name>/`** — per-machine system config. Entry is `configuration.nix`. Linux hosts
  also import `hardware-configuration.nix`, `nvidia.nix`, `bootloader.nix`, `users.nix`.
- **`modules/`** — reusable system-level NixOS/darwin modules, composed into hosts via the
  module lists in `flake.nix` (not auto-imported). Subdirs (`development/`, `apps/`,
  `virtualisation/`, `jetbrains/`) have a `default.nix` that imports siblings.
- **`home/`** — Home Manager modules (shell, kitty, neovim, desktop/Hyprland). Composed into
  `homeConfigurations` module lists. `home/desktop/` is Linux/Wayland-only.
- **`pkgs/`** — custom packages. `pkgs/default.nix` exposes each via `callPackage ./<name>`,
  surfaced as flake `packages.<system>`. Most are `writeShellScriptBin` wrappers (see
  `pkgs/devtag`) that reference dependencies by full Nix store path (`${pkgs.git}/bin/git`)
  rather than relying on `PATH`.

### Adding things

- **New custom package**: create `pkgs/<name>/default.nix`, then add a `callPackage` line to
  `pkgs/default.nix`.
- **New module**: create the `.nix` file under `modules/`, then add it to the relevant host's
  module list in `flake.nix` (or to a subdir `default.nix`'s `imports`).
- **New host**: create `hosts/<name>/`, add a `nixosConfigurations`/`darwinConfigurations`
  entry in `flake.nix` with its module list and `specialArgs`.

### specialArgs / extraSpecialArgs

Modules receive extra arguments beyond the standard `config`/`pkgs`/`lib`:
`user`, `self`, `inputs`, `outputs`, and (on the MBP darwin config) `stablePkgs` /
`unstablePkgs`. `unstablePkgs` is `nixpkgs-unstable` with `allowUnfree`; use it to pull a
package that isn't yet in the pinned stable channel. The pinned channel is `nixos-25.11`
(see `inputs` in `flake.nix`); `nix-darwin` and `home-manager` follow the same release.
