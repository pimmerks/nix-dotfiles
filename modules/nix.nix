{ lib, ...}: {
  nix = {
    settings = {
      trusted-users = [ "root" "@wheel" ];
      warn-dirty = false;
    };
  };
}
