{ pkgs, ... }:

{
  imports = [
    (import ../../modules/neovim.nix)
    (import ../../modules/git.nix)
    (import ../../modules/fish.nix)
    (import ../../modules/alacritty)
  ];

  fonts = {
    fontDir.enable = true;
    fontconfig = {
      enable = true;
    };
    fonts = [ pkgs.fantasque-sans-mono ];
  };
}
