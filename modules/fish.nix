{ pkgs, config, ...}:

{
  programs.fish = {
    enable = true;

    functions = {
      fish_greeting = {
        body = ''
        '';
      };
    };
  };
}
