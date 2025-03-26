{
  stdenv,
  pkgs,
  ...
}: let
  scriptName = "volume-control";

  notify-send = "${pkgs.libnotify}/bin/notify-send";
  pamixer = "${pkgs.pamixer}/bin/pamixer";

  script = pkgs.writeShellScriptBin "${scriptName}" ''
    down() {
        ${pamixer} -d 5
        volume=$(${pamixer} --get-volume)
        ${notify-send} -t 750 -a "Volume" -u low "Volume down (''${volume}%)"
    }

    up() {
        ${pamixer} -i 5
        volume=$(${pamixer} --get-volume)
        ${notify-send} -t 750 -a "Volume" -u low "Volume up (''${volume}%)"
    }

    mute() {
        muted="$(${pamixer} --get-mute)"
        if $muted; then
            ${pamixer} -u
            ${notify-send} -t 750 -a "Volume" -u low "Unmuted"
        else
            ${pamixer} -m
            ${notify-send} -t 750 -a "Volume" -u low "Muted"
        fi
    }

    muteMicrophone() {
        muted="$(${pamixer} --default-source --get-mute)"
        if $muted; then
            ${pamixer} --default-source -u
            ${notify-send} -t 1000 -a "Volume" -u low "Unmuted"
        else
            ${pamixer} --default-source -m
            ${notify-send} -t 1000 -a "Volume" -u low "Muted"
        fi
    }

    case "$1" in
      up) up;;
      down) down;;
      mute) mute;;
      mutemic) muteMicrophone;;
    esac
  '';
in
  stdenv.mkDerivation {
    name = scriptName;
    src = script;
    phases = "installPhase";

    buildInputs = [
      pkgs.libnotify
      pkgs.pamixer
    ];

    installPhase = ''
      mkdir -p $out/bin
      install -Dm 744 $src/bin/${scriptName} $out/bin/${scriptName}
    '';
  }
