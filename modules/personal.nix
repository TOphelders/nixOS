{ pkgs, ...}:

with pkgs;

{
  home.packages = [
    cargo-tauri
  ];
}
