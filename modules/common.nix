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
    unzip
    wget

    kind
    kubectl
    kubernetes-helm

    nodejs
    yarn

    python310

    roboto-mono
  ];
}