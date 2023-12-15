{
  description = "My NixOS & MacOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-stable.url = "nixpkgs/nixos-23.11";

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

  outputs = inputs@{ self, nixpkgs, nix-stable, nix-darwin, home-manager, hyprland }:
  let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib // nix-darwin.lib;
    overlay-stable = final: prev: {
      stable = nix-stable.legacyPackages.${prev.system};
    };
  in {
    inherit lib;

    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Pims-MacBook-Pro
    darwinConfigurations."Pims-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [
        ./hosts/Pims-MacBook-Pro/configuration.nix
        ./modules/common.nix
        ./modules/cli_tools.nix
      ];
      specialArgs = {
        user = "pimmer";
        inherit self inputs outputs;
      };
    };

     # New MBP M3 - Arm chip
    darwinConfigurations."Pims-MBP" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./hosts/Pims-MBP/configuration.nix
#        ./modules/common.nix
#        ./modules/cli_tools.nix

        ./modules/development
#        ./modules/terminal.nix

        ./modules/apps/spotify.nix

      ];
      specialArgs = {
        user = "pimmer";
        homeDir = "/Users/pimmer";
        inherit self inputs outputs;
      };
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Pims-MBP".pkgs;

    # Main desktop
    # Build darwin flake using:
    # $ nixos-rebuild build --flake .#lin0
    nixosConfigurations."lin0" = lib.nixosSystem {
      modules = [
        # Overlays-module makes "pkgs.stable" available in configuration.nix
        ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-stable ]; })

        ./hosts/lin0/configuration.nix
        ./modules/common.nix
        ./modules/shell.nix
        ./modules/hyprland.nix
        ./modules/development.nix
        ./modules/docker.nix
        ./modules/1password.nix
        ./modules/gaming.nix
        ./modules/virtualisation.nix
      ];

      specialArgs = {
        user = "pimmer";
        homeDir = "/home/pimmer";
        nix-stable = nix-stable;
        inherit self inputs outputs;
      };
    };

    homeConfigurations."pimmer@lin0" = lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;

      modules = [
        hyprland.homeManagerModules.default
        ./home
      ];

      specialArgs = {
        user = "pimmer";
        homeDir = "/home/pimmer";
        inherit self inputs outputs;
      };
    };

    homeConfigurations = {
      "pimmer@Pims-MBP" = home-manager.lib.homeManagerConfiguration {
        # Note: I am sure this could be done better with flake-utils or something
        pkgs = import nixpkgs { system = "aarch64-darwin"; };

        modules = [
          {
            home = {
              username = "pimmer";
              homeDirectory = "/Users/pimmer";
              stateVersion = "23.11";
            };
          }
          ./home/shell.nix
          ./home/kitty.nix
          ./home/neovim.nix
        ];
      };
    };
  };
}
