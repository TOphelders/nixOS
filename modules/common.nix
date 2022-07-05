{ pkgs, ...}:

with pkgs;

{
  home.packages = [
    curl
    git
    jq
    j2cli
    openssl
    silver-searcher
    universal-ctags
    unzip
    wget

    kind
    kubectl
    kubectx
    kubernetes-helm

    google-cloud-sdk
    terraform

    nodejs
    yarn

    python310

    roboto-mono
  ];
}
