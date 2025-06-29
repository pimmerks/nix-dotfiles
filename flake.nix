{
  description = "My NixOS & MacOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nix-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nix-unstable,
    nix-darwin,
    home-manager,
    hyprland,
  }: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib // nix-darwin.lib;
    systems = ["x86_64-linux" "aarch64-darwin"];

    forEachSystem = f:
      lib.genAttrs systems (system: f system pkgsFor.${system});

    pkgsFor = lib.genAttrs systems (system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      });

    unstablePkgsFor = lib.genAttrs systems (system:
      import nix-unstable {
        inherit system;
        config.allowUnfree = true;
      });
  in {
    inherit lib;
    packages = forEachSystem (system: pkgs: import ./pkgs {inherit pkgs;});
    formatter = forEachSystem (system: pkgs: pkgsFor.${system}.alejandra);
    devShells = forEachSystem (system: pkgs: {
      default = pkgs.mkShell {
        buildInputs = [
          pkgs.deadnix
          pkgs.alejandra
          pkgs.nix-search-cli
          pkgs.git
          pkgs.gnumake
        ];
      };
    });

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

        ./modules/nix.nix
      ];
      specialArgs = {
        user = "pimmer";
        inherit self inputs outputs;
        unstablePkgs = unstablePkgsFor.aarch64-darwin;
      };
    };

    # Main desktop
    # Build darwin flake using:
    # $ nixos-rebuild build --flake .#lin0
    nixosConfigurations."lin0" = lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/lin0/configuration.nix

        ./modules/dev
        ./modules/dev/python.nix

        # ./modules/jetbrains
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
        unstablePkgs = unstablePkgsFor.x86_64-linux;
      };
    };

    homeConfigurations = {
      "pimmer@Pims-MBP" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor.aarch64-darwin;
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
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = {
          inherit self inputs outputs;
          unstablePkgs = unstablePkgsFor.x86_64-linux;
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
          ./home/git.nix
          ./home/neovim
          ./home/desktop
        ];
      };
    };
  };
}
