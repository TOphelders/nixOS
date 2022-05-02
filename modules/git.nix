{ ... }:

{
  programs.git = {
    delta = {
      enable = true;
      options = {
        hunk-header-style = "omit";
        syntax-theme = "GitHub";
        navigate = "true";
        side-by-side = "true";
        line-numbers = "true";
      };
    };

    enable = true;

    ignores = [
    ];

    userEmail = "t.ophelders@gmail.com";
    userName = "Trevor Ophelders";

    extraConfig = {
      github.user = "t.ophelders@gmail.com";

      init = {
        defaultBranch = "main";
      };

      pull = {
        rebase = true;
      };

      diff = {
        colorMoved = "default";
      };

      difftool = {
        prompt = false;
      };

      "difftool \"nvim\"" = {
        cmd = "nvim -d $BASE $LOCAL $REMOTE $MERGED -c '$wincmd w' -c 'wincmd J'";
      };

      merge = {
        conflictStyle = "diff3";
      };

      "mergetool \"nvim-merge\"" = {
        cmd = "nvim -d $BASE $LOCAL $REMOTE $MERGED -c '$wincmd w' -c 'wincmd J'";
      };

      mergetool = {
        prompt = true;
      };

      core = {
        editor = "nvim";
        ignorecase = false;
      };
    };
  };
}
