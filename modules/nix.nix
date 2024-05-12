{ lib, inputs, ...}: {
  nix = {
    settings = {
      trusted-users = [ "root" "@wheel" "@staff" ];
      warn-dirty = false;
    };

    # Use the same registry as our flake inputs.
    registry = {
      nixpkgs.flake = inputs.nixpkgs;
    };
  };
}
