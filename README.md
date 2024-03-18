# Nix dotfiles

My nixos/macos configuration as a flake. Including dotfiles/home-manager/packages.

## Getting started

Clone the repository and, depending on the system, execute the following commands:


### NixOS

```shell
sudo nixos-rebuild switch --flake .#lin0
```

### MacOS

First time, install `nix-darwin` with:

```shell
nix --extra-experimental-features 'nix-command flakes' run nix-darwin -- switch --flake .#Pims-MacBook-Pro
```

After `nix-darwin` is installed, you're able to run `darwin-rebuild` to rebuild the system.

```shell
darwin-rebuild switch --flake .#Pims-MacBook-Pro
```

### Updating programs

Updating the nix lock file result in updated installed apps.

```shell
nix flake update --commit-lock-file
```

After this, you have to rebuild your NixOS config, as seen above.
