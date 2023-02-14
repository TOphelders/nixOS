{ pkgs, home-manager, config, ... }:

{
  home.username = "trevor";
  home.homeDirectory = "/Users/trevor";
  home.stateVersion = "23.05";

  imports = [
    (import ../../modules/common.nix)
    (import ../../modules/git.nix)
    (import ../../modules/fish.nix)
    (import ../../modules/neovim.nix)
    (import ../../modules/rust.nix)
  ];

  programs.man.enable = true;

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes
    keep-derivations = true
    keep-outputs = true
  '';

  home.file = {
    ".ctags.d/tsx.ctags" = {
      text = ''
        --exclude=*.git*
        --exclude=.DS_Store
        --exclude=node_modules

        --langmap=JavaScript:+.ts.tsx
      '';
      recursive = true;
    };
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    nixFlakes
    unixtools.watch
    home-manager.defaultPackage.aarch64-darwin
  ];
}
