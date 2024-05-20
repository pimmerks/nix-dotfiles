{ pkgs }:
with pkgs; {
  audio-output-changer = callPackage ./audio-output-changer { };
  cliphist-rofi = callPackage ./cliphist-rofi { };
  monitor-brightness = callPackage ./monitor-brightness { };
  power-menu-rofi = callPackage ./power-menu-rofi { };
  screenshot-copy = callPackage ./screenshot-copy { };
  volume-control = callPackage ./volume-control { };
}
