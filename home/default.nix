{ inputs, outputs, pkgs, user, lib, nixvim, ... }:
let
  inherit (inputs.nix-colors) colorSchemes;
  inherit user;
in {
  imports = [
    ./kitty
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "23.11";
  };
}
