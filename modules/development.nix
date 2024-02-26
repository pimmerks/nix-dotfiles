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
    go_1_22
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
    aws-iam-authenticator
    gh
    dapr-cli
    argocd
    supabase-cli

    # Kubernetes
    kubectl
    kubectx
    stern # Multi pod and container log tailing for Kubernetes
    k9s
    kubernetes-helm
    kubernetes-helmPlugins.helm-diff
    helm-docs
    kubelogin
    kustomize

    # Terraform
    terraform
    terraform-docs
  ];
}
