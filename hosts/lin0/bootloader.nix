{ config, pkgs, ... }: {
  # Bootloader.
  boot = {
    supportedFilesystems = [ "ntfs" ];
    initrd = { kernelModules = [ "nvidia" ]; };
    extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
    loader = {
      efi = {
        canTouchEfiVariables = true;
      };

      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 10;
        gfxmodeEfi = "1920x1080";

        theme = pkgs.fetchzip {
          # https://github.com/AdisonCavani/distro-grub-themes
          url = "https://github.com/AdisonCavani/distro-grub-themes/raw/master/themes/nixos.tar";
          hash = "sha256-KQAXNK6sWnUVwOvYzVfolYlEtzFobL2wmDvO8iESUYE=";
          stripRoot = false;
        };
      };

      #      systemd-boot = {
      #        enable = true;
      #      };
    };
  };
}
