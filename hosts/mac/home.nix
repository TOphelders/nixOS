{ pkgs, home-manager, config, ... }:

{
  imports = [
    (import ../../modules/common.nix)
    (import ../../modules/git.nix)
    (import ../../modules/fish.nix)
    (import ../../modules/neovim.nix)
    (import ../../modules/rust.nix)
  ];

  programs.man.enable = true;

  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes
    keep-derivations = true
    keep-outputs = true
  '';

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    nixFlakes
    unixtools.watch
    home-manager.defaultPackage.aarch64-darwin
  ];
}
