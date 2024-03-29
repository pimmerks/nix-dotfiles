{ pkgs, user, lib, ... }:

let

  font_options =
    if lib.strings.hasSuffix "darwin" pkgs.system
    then {
           fontDir.enable = true;
           fonts = with pkgs; [
             (nerdfonts.override {
               fonts = [ "Meslo" "FiraCode" "JetBrainsMono" ];
             })
           ];
         }
    else {
           packages = with pkgs; [
             dejavu_fonts
             freefont_ttf
             gyre-fonts # TrueType substitutes for standard PostScript fonts
             liberation_ttf
             unifont
             noto-fonts-color-emoji
             noto-fonts
             noto-fonts-cjk
             noto-fonts-emoji
             font-awesome
             (nerdfonts.override { fonts = [ "Meslo" "FiraCode" "JetBrainsMono" ]; })
           ];
         };

in

{
  fonts = font_options;
}
