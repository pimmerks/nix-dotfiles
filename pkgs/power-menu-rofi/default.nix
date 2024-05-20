{ stdenv, pkgs, ... }:
let
  scriptName = "power-menu-rofi";

  awk = "${pkgs.gawk}/bin/awk";
  rofi = "${pkgs.rofi-wayland}/bin/rofi";
  sleep = "${pkgs.coreutils}/bin/sleep";
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  loginctl = "${pkgs.systemd}/bin/loginctl";
  systemctl = "${pkgs.systemd}/bin/systemctl";

  script = pkgs.writeShellScriptBin "${scriptName}" ''
    entries="Lock,Suspend,Logout,Reboot,Shutdown"

    selected=$(echo ''${entries} | ${rofi} -m 0 -dmenu -sep ',' -p "Powermenu" -i | ${awk} '{print tolower($1)}')

    case $selected in
      logout)
        exec ${hyprctl} dispatch exit;;
      lock)
        exec ${sleep} 1 && hyprctl dispatch dpms off;;
      suspend)
        exec ${systemctl} suspend;;
      reboot)
        exec ${systemctl} reboot;;
      shutdown)
        exec ${systemctl} poweroff -i;;
    esac
  '';

in stdenv.mkDerivation {
  name = scriptName;
  src = script;
  phases = "installPhase";

  buildInputs = [
    pkgs.gawk
    pkgs.rofi-wayland
    pkgs.coreutils
    pkgs.hyprland
    pkgs.systemd
  ];

  installPhase = ''
    mkdir -p $out/bin
    install -Dm 744 $src/bin/${scriptName} $out/bin/${scriptName}
  '';
}
