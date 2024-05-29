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

    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, ... }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib // nix-darwin.lib;

      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      checks = forAllSystems (system: {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixpkgs-fmt.enable = true;
            nil.enable = true;
            deadnix.enable = true;
            flake-checker.enable = true;
          };
        };
      });

      devShells = forAllSystems (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
        };
      });

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

      darwinConfigurations = {
        "Pims-MacBook-Pro" = nix-darwin.lib.darwinSystem {
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

        "Pims-MBP" = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./hosts/Pims-MBP/configuration.nix

            ./modules/development
            ./modules/apps/spotify.nix
            ./modules/apps/discord.nix
            ./modules/apps/1password_cli.nix
            ./modules/fonts.nix

            ./modules/nix.nix
          ];
          specialArgs = {
            user = "pimmer";
            inherit self inputs outputs;
          };
        };
      };

      homeConfigurations = {
        "pimmer@Pims-MBP" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgsFor.aarch64-darwin;
          extraSpecialArgs = {
            inherit self inputs outputs;
          };
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
          pkgs = nixpkgsFor.x86_64-linux;
          extraSpecialArgs = {
            inherit self inputs outputs;
          };
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
            ./home/desktop
          ];
        };
      };
    };
}
