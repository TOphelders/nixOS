{ lib, config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;

    settings = {
      colors = (import ./colors.nix).tokyo-night;
      font = (import ./fonts.nix).roboto-mono;
      env = {
        TERM = "alacritty";
      };
    };
  };
}
