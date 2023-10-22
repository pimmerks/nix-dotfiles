# Nix dotfiles

My nixos/macos configuration as a flake. Including dotfiles/home-manager/packages.

## Getting started

Clone the repository and, depending on the system, execute the following commands:

### MacOS

First time, install `nix-darwin` with:
```shell
nix run nix-darwin -- switch --flake ./
```

After `nix-darwin` is installed, you're able to run `darwin-rebuild` to rebuild the system.
```shell
darwin-rebuild switch --flake .#Pims-MacBook-Pro
```

### NixOS
```shell
sudo nixos-rebuild switch --flake .#lin0
```
