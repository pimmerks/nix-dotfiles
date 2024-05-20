# Nix dotfiles

My nixos/macos configuration as a flake. Including dotfiles/home-manager/packages.

## Getting started

Clone the repository and, depending on the system, execute the following commands:

```shell
# Build the flake to ./result
make build

# Switch the system to the newest version of this flake
make switch
```

## Home Manager
```shell
# Build the flake to ./result
make hmbuild

# Switch the system to the newest version of this flake
make hmswitch

# View news
make hmnews
```

## Updating lock file

```shell
make update
```
