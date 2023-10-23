{
  description = "My NixOS & MacOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, hyprland }:
  let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib // nix-darwin.lib;
  in {
    inherit lib;

    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Pims-MacBook-Pro
    darwinConfigurations."Pims-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [
        ./hosts/Pims-MacBook-Pro/configuration.nix
      ];
      specialArgs = {
        user = "pimmer";
        inherit self inputs outputs;
      };
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Pims-MacBook-Pro".pkgs;

    # Main desktop
    # Build darwin flake using:
    # $ nixos-rebuild build --flake .#lin0
    nixosConfigurations."lin0" = lib.nixosSystem {
      modules = [
        ./hosts/lin0/configuration.nix
        ./modules/common.nix
        ./modules/shell.nix
        ./modules/hyprland.nix
        ./modules/development.nix
        ./modules/docker.nix
        ./modules/1password.nix
      ];

      specialArgs = {
        user = "pimmer";
        inherit self inputs outputs;
      };
    };
  };
}
