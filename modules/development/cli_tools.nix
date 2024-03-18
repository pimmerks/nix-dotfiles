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

    # network
    curl
    wget

    # CLI
    glab # Gitlab cli
    awscli2 # AWS
    gh
    dapr-cli
    argocd

    # Kubernetes
    kubectl
    kubectx
    stern # Multi pod and container log tailing for Kubernetes
    k9s
    kubernetes-helm
    helm-docs
    kubelogin
    kustomize

    # Terraform
    terraform
    terraform-docs
  ];
}
