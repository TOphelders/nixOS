{ lib, config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;

    settings = {
      colors = (import ./colors.nix).oxide;
      font = (import ./fonts.nix).fantasque-sans-mono;
      env = {
        TERM = "alacritty";
      };
    };
  };
}
