{ pkgs, ... }:

{
  imports = [
    (import ../../modules/common.nix)
    (import ../../modules/git.nix)
    (import ../../modules/fish.nix)
    (import ../../modules/neovim.nix)
    (import ../../modules/alacritty)
  ];
}
