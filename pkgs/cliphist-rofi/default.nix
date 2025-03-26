{
  stdenv,
  pkgs,
  ...
}: let
  scriptName = "cliphist-rofi";

  cliphist = "${pkgs.cliphist}/bin/cliphist";
  wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";

  script = pkgs.writeShellScriptBin "${scriptName}" ''
    # https://github.com/sentriz/cliphist/blob/master/contrib/cliphist-rofi
    if [ -z "$1" ]; then
        ${cliphist} list
    else
        ${cliphist} decode <<<"$1" | ${wl-copy}
    fi
  '';
in
  stdenv.mkDerivation {
    name = scriptName;
    src = script;
    phases = "installPhase";

    buildInputs = [
      pkgs.cliphist
      pkgs.wl-clipboard
    ];

    installPhase = ''
      mkdir -p $out/bin
      install -Dm 744 $src/bin/${scriptName} $out/bin/${scriptName}
    '';
  }
