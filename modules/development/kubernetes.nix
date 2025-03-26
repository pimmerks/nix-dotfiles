{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Kubernetes
    kubectl
    kubelogin-oidc
    kubectx
    kubernetes-helm
    kubernetes-helmPlugins.helm-diff

    argocd

    # Kubernetes
    kubectl
    kubectx
    stern # Multi pod and container log tailing for Kubernetes
    # k9s Installed by home-manager
    helm-docs
    kubelogin
    kustomize

    # Local kubernetes on docker
    kind
  ];
}
