{ stdenv, pkgs, ... }:
let
  scriptName = "lockscreen-album-art";

  playerctl = "${pkgs.playerctl}/bin/playerctl";
  sed = "${pkgs.gnused}/bin/sed";
  curl = "${pkgs.curl}/bin/curl";
  convert = "${pkgs.imagemagick}/bin/convert";

  #  playerctl metadata mpris:artUrl | sed "s/open\.spotify\.com/i.scdn.co/"
  script = pkgs.writeShellScriptBin "${scriptName}" ''
    ALBUM_URL="$(${playerctl} metadata mpris:artUrl)"
    ALBUM_ID="$(echo $ALBUM_URL | awk -F '/' '{print $NF}')"
    FILE=/tmp/now-playing-$ALBUM_ID

    if [[ -z $ALBUM_URL ]]; then
      exit 0
    fi

    if [[ -f "$FILE" ]]; then
      printf $FILE.png
      exit 0
    fi

    ${curl} -s $ALBUM_URL > $FILE
    # Convert the image to png
    ${convert} -format png $FILE $FILE.png
    rm -f $FILE
    ln -fs $FILE.png /tmp/now-playing.png
    printf "$FILE.png"
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
