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

        ./modules/development
        ./modules/apps/spotify.nix
        ./modules/apps/discord.nix
        ./modules/apps/1password_cli.nix
        ./modules/fonts.nix
      ];
      specialArgs = {
        user = "pimmer";
        inherit self inputs outputs;
      };
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Pims-MBP".pkgs;

    # Main desktop
    # Build darwin flake using:
    # $ nixos-rebuild build --flake .#lin0
    nixosConfigurations."lin0" = lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/lin0/configuration.nix

        ./modules/development
        ./modules/jetbrains
        ./modules/apps/spotify.nix
        ./modules/apps/discord.nix
        ./modules/apps/1password_cli.nix

        ./modules/nix.nix

        ./modules/virtualisation/docker.nix
        ./modules/virtualisation/vms.nix

        ./modules/common.nix
        ./modules/hyprland.nix
        ./modules/1password.nix

        ./modules/gaming.nix
        ./modules/fonts.nix
      ];

      specialArgs = {
        user = "pimmer";
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
          ./home/neovim
        ];
      };

      "pimmer@lin0" = home-manager.lib.homeManagerConfiguration {
        # Note: I am sure this could be done better with flake-utils or something
        pkgs = import nixpkgs { system = "x86_64-linux"; };
        modules = [
          {
            home = {
              username = "pimmer";
              homeDirectory = "/home/pimmer";
              stateVersion = "23.11";
            };
          }

          ./home/shell.nix
          ./home/kitty.nix
          ./home/neovim
        ];
      };
    };
  };
}
