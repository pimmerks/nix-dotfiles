{ stdenv, pkgs, ... }:
let
  scriptName = "monitor-brightness";

  ddcutil = "${pkgs.ddcutil}/bin/ddcutil";
  grep = "${pkgs.gnugrep}/bin/grep";
  awk = "${pkgs.gawk}/bin/awk";
  notify-send = "${pkgs.libnotify}/bin/notify-send";

  # ddcutil detect output:
  #  Display 1
  #     I2C bus:          /dev/i2c-3
  #     DRM connector:    card1-HDMI-A-1
  #     Monitor:          GSM:LG IPS FULLHD:
  #
  #  Display 2
  #     I2C bus:          /dev/i2c-4
  #     DRM connector:    card1-HDMI-A-2
  #     Monitor:          GSM:LG IPS FULLHD:

  script = pkgs.writeShellScriptBin "${scriptName}" ''
    i2c_buses=($(${ddcutil} detect --brief | ${grep} 'I2C bus:' | ${awk} '{print $3}' | ${awk} -F'-' '{print $2}'))
    CUR_BRIGHTNESS=$(${ddcutil} getvcp --brief 0x10 --bus 4 | ${awk} '{print $4}')
    NEW_BRIGHTNESS=100

    echo "Current: $CUR_BRIGHTNESS"

    case "$1" in
      up) NEW_BRIGHTNESS=$(($CUR_BRIGHTNESS + 25));;
      down) NEW_BRIGHTNESS=$(($CUR_BRIGHTNESS - 25));;
    esac

    if [[ $NEW_BRIGHTNESS -lt 0 ]]; then
      NEW_BRIGHTNESS=0
    fi

    if [[ $NEW_BRIGHTNESS -gt 100 ]]; then
      NEW_BRIGHTNESS=100
    fi

    echo "New: $NEW_BRIGHTNESS"

    for bus in "''${i2c_buses[@]}"; {
      ${ddcutil} setvcp 0x10 $NEW_BRIGHTNESS --bus $bus
    }

    ${notify-send} "Set brightness to $NEW_BRIGHTNESS" -t 1000
  '';

in stdenv.mkDerivation {
  name = scriptName;
  src = script;
  phases = "installPhase";

  buildInputs = [
    pkgs.ddcutil
    pkgs.gnugrep
    pkgs.gawk
    pkgs.libnotify
  ];

  installPhase = ''
    mkdir -p $out/bin
    install -Dm 744 $src/bin/${scriptName} $out/bin/${scriptName}
  '';
}
