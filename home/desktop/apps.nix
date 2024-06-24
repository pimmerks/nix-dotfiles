{ config, self, pkgs, lib, ... }: {
  home.packages = [ self.packages.${pkgs.system}.gchat ];
}
