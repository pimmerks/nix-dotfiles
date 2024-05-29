{ stdenv, pkgs, ... }:
let
  scriptName = "screenshot-copy";

  grimshot = "${pkgs.sway-contrib.grimshot}/bin/grimshot";
  wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";

  script = pkgs.writeShellScriptBin "${scriptName}" ''
    # Make a screenshot, save it and then copy it to clipboard.
    FILE="''${HOME}/Pictures/Screenshots/$(date +'%s_screenshot.png')"

    ${grimshot} --notify save area "$FILE"

    ${wl-copy} < "$FILE"
  '';

in
stdenv.mkDerivation {
  name = scriptName;
  src = script;
  phases = "installPhase";

  buildInputs = [
    pkgs.sway-contrib.grimshot
    pkgs.wl-clipboard
  ];

  installPhase = ''
    mkdir -p $out/bin
    install -Dm 744 $src/bin/${scriptName} $out/bin/${scriptName}
  '';
}
