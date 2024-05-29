{ stdenv, pkgs, ... }:
let
  scriptName = "lockscreen-album-art";

  playerctl = "${pkgs.playerctl}/bin/playerctl";
  sed = "${pkgs.gnused}/bin/sed";
  curl = "${pkgs.curl}/bin/curl";
  convert = "${pkgs.imagemagick}/bin/convert";

  #  playerctl metadata mpris:artUrl | sed "s/open\.spotify\.com/i.scdn.co/"
  script = pkgs.writeShellScriptBin "${scriptName}" ''
    ALBUM_URL=$(${playerctl} metadata mpris:artUrl | ${sed} "s/open\.spotify\.com/i.scdn.co/")

    if [[ -z $ALBUM_URL ]]; then
      exit 0
    fi

    ${curl} $ALBUM_URL > /tmp/now-playing-album-raw
    ${convert} /tmp/now-playing-album-raw /tmp/now-playing.jpg
    echo /tmp/now-playing.jpg
  '';

in stdenv.mkDerivation {
  name = scriptName;
  src = script;
  phases = "installPhase";

  buildInputs = [
    pkgs.playerctl
    pkgs.gnused
    pkgs.curl
    pkgs.imagemagick
  ];

  installPhase = ''
    mkdir -p $out/bin
    install -Dm 744 $src/bin/${scriptName} $out/bin/${scriptName}
  '';
}
