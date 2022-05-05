{ pkgs, config, ...}:

{
  programs.fish = {
    enable = true;

    functions = {
      mount_shared = {
        body = ''
          vmhgfs-fuse .host:/Shared /home/trevor/shared -o subtype=vmhgfs-fuse
        '';
      };
    };
  };
}
