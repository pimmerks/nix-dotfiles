{ config, pkgs, ... }:
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # VCS
    git

    # Editors
    vim
    neovim

    # golang tools
    golangci-lint
    govulncheck

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
    curl
    wget
    dig

    # CLI
    glab # Gitlab cli
    awscli2 # AWS
    gh
    dapr-cli
    supabase-cli
    stripe-cli
    azure-cli

    # Terraform
    terraform
    terraform-docs

    # OPA
    open-policy-agent

    # Ansible
    ansible
    ansible-lint
    sshpass
  ];
}
