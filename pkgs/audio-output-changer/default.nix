{ pkgs, ... }:
let
  python3Packages = pkgs.python312Packages;
in
python3Packages.buildPythonApplication rec {
  pname = "audio-output-changer";
  version = "1.0.0";
  pyproject = true;

  src = ./pkg;

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = [
    pkgs.wireplumber
  ];
}
