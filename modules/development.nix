{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Editors / tools
    jetbrains.goland
    jetbrains.webstorm
    vscode
    insomnia

    ### Languages

    # Golang
    go_1_21
    golangci-lint
    goose
    gcc
    libcap

    # NodeJS
    nodejs_20
    bun

    # Python
    python312

    ### Tools
    gnumake
    grpcurl

    # Proto
    protobuf
    protoc-gen-go
    protoc-gen-go-grpc
    protoc-gen-doc

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
