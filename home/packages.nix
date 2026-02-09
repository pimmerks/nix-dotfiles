{
  config,
  pkgs,
  ...
}: {
  # Packages that should be installed to the user profile.
  home.packages = [
    pkgs.zsh-autosuggestions
    pkgs.fasd # needed for 'z' jump-around
    pkgs.ripgrep # Faster grep
    pkgs.fd # Faster find
    pkgs.bat # Better cat
    pkgs.difftastic # Better diffing
    # pkgs.pre-commit # Pre-commit hooks for git repositories
    pkgs.uv # Python package manager
    pkgs.minio-client # S3 cli client
    pkgs.nom # RSS Feed Reader
    pkgs.pnpm
    pkgs.claude-code # Claude Code
    pkgs.opencode
  ];
}
