{
  config,
  self,
  pkgs,
  lib,
  ...
}: {
  home.packages = [self.packages.${pkgs.stdenv.hostPlatform.system}.gchat];
}
