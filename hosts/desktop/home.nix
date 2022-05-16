{ pkgs, ... }:

{
  imports = [
    (import ../../modules/git.nix)
    (import ../../modules/fish.nix)
    (import ../../modules/neovim.nix)
    (import ../../modules/alacritty)
  ];
}
