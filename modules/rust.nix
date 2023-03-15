{ pkgs, ...}:

let

  rust = pkgs.rust-bin.stable.latest.default.override {
    extensions = [ "rust-analyzer" "rust-analysis" "rust-src" ];
  };

in 
{
  home.packages = [
    pkgs.dbmate
    rust
  ];
}
