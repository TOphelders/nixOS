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
    kubernetes-helm

    nodejs
    yarn

    python310
    python310Packages.pylint

    roboto-mono
  ];
}
