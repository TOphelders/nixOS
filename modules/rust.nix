{ pkgs, ...}:

let

  rust = pkgs.rust-bin.stable.latest.default.override {
    extensions = [ "rls" "rust-analysis" "rust-src" ];
  };

in 
{
  home.packages = [
    rust
  ];
}
