{ pkgs, config, ...}:

let

  fishConfig = ''
    fish_add_path /opt/local/bin /opt/local/sbin
    contains "/Users/trevor/.nix-profile/share/man" $MANPATH
    or set -p MANPATH "/Users/trevor/.nix-profile/share/man"

    # nix
    if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    end
  '';

in
{
  programs.fish = {
    enable = true;

    interactiveShellInit = fishConfig;

    functions = {
      mount_shared = {
        body = ''
        '';
      };
    };

    plugins = [
      {
        name = "fenv";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-foreign-env";
          rev = "b3dd471bcc885b597c3922e4de836e06415e52dd";
          sha256 = "3h03WQrBZmTXZLkQh1oVyhv6zlyYsSDS7HTHr+7WjY8=";
        };
      }
    ];
  };
}
