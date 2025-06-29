{
  pkgs,
  lib,
  ...
}: {
  fonts =
    if lib.strings.hasSuffix "darwin" pkgs.system
    then {
      packages = with pkgs; [
        font-awesome
        meslo-lg
        fira-code
        jetbrains-mono
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
        noto-fonts-cjk-sans
        noto-fonts-emoji
        font-awesome
        meslo-lg
        fira-code
        jetbrains-mono
      ];
    };
}
