{
  config,
  pkgs,
  ...
}: {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git

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
    # k9s
    kubernetes-helm
    helm-docs
    kubelogin
    kustomize

    # Terraform
    terraform
    terraform-docs
  ];
}
