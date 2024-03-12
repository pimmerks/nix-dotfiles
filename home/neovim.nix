{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;

    # Set as default editor, including aliases.
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # Adds os clipboard support to nvim.
    extraConfig = ''
if has("unnamedplus")
    set clipboard=unnamedplus
else
    set clipboard=unnamed
endif
    '';

  };
}
