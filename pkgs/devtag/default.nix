{
  stdenv,
  pkgs,
  ...
}: let
  scriptName = "devtag";

  git = "${pkgs.git}/bin/git";
  wc = "${pkgs.coreutils}/bin/wc";

  script = pkgs.writeShellScriptBin "${scriptName}" ''
    TAG=$1

    # Check if tag is provided
    if [ -z $TAG ]; then
      echo "No tag provided";
      exit 1;
    fi

    # Check regex
    if [[ ! "$TAG" =~ ^dev-.*$ ]]; then
      echo "Devtag does not pass regex: should start with 'dev-': $TAG";
      exit 1;
    fi

    # Check if in git repo
    IN_REPO=$(${git} rev-parse --is-inside-work-tree 2> /dev/null)
    if [[ "$IN_REPO" != "true" ]]; then
      echo "Not in git repo";
      exit 1;
    fi

    echo "Creating dev-tag: $TAG ...";

    # Now we have done all the pre-checking, lets remove the tag first from local and remote if they exist
    # Local:
    if [[ $(${git} tag -l "$TAG" 2>/dev/null | wc -l) != "0" ]]; then
      echo "> removing local tag $TAG ...";
      ${git} tag -d "$TAG"
    fi

    # Remote:
    if [[ $(${git} ls-remote --tags origin "refs/tags/$TAG" 2>/dev/null | ${wc} -l) != "0" ]]; then
      echo "> removing remote tag refs/tags/$TAG ...";
      ${git} push origin ":refs/tags/$TAG"
    fi

    echo "> creating local tag ...";
    ${git} tag "$TAG";

    echo "> pushing local tag ...";
    ${git} push origin "$TAG";
  '';
in
  stdenv.mkDerivation {
    name = scriptName;
    src = script;
    phases = "installPhase";

    buildInputs = [
      pkgs.git
      pkgs.coreutils
    ];

    installPhase = ''
      mkdir -p $out/bin
      install -Dm 744 $src/bin/${scriptName} $out/bin/${scriptName}
    '';
  }

