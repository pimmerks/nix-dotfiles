{
  config,
  pkgs,
  stablePkgs,
  ...
}: {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # VCS
    stablePkgs.git
    nh

    # Editors
    vim
    neovim

    # golang tools
    golangci-lint
    govulncheck
    gofumpt
    gotools

    # Tools
    gnumake
    grpcurl

    # Proto
    protobuf
    protoc-gen-go
    protoc-gen-go-grpc
    protoc-gen-doc
    buf

    # misc
    tmux
    jq
    yq
    tree
    glances
    watch
    htop
    killall
    neofetch
    fzf
    unzip
    gotop

    # network
    stablePkgs.curl
    wget
    dig

    # CLI
    glab # Gitlab cli
    awscli2 # AWS
    aws-iam-authenticator # AWS
    gh
    dapr-cli
    supabase-cli
    stripe-cli
    azure-cli

    # Terraform
    # terraform-docs
    opentofu

    # OPA
    # open-policy-agent

    # Ansible
    ansible
    ansible-lint
    sshpass

    # Python
    ruff
    pyright
  ];
}
