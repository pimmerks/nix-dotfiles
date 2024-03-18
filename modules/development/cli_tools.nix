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

    # CLI
    glab # Gitlab cli
    awscli2 # AWS
    aws-iam-authenticator
    gh
    dapr-cli
    argocd

    # Terraform
    terraform
    terraform-docs
  ];
}
