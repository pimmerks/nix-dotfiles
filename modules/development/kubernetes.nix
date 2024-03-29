{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Kubernetes
    kubectl
    kubectx
    kubernetes-helm
    kubernetes-helmPlugins.helm-diff

    argocd

    # Kubernetes
    kubectl
    kubectx
    stern # Multi pod and container log tailing for Kubernetes
    k9s
    helm-docs
    kubelogin
    kustomize
  ];
}
