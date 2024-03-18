{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
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
  ];
}
