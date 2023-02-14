# System Flake

## Mac
```
$ cat /etc/nix/nix.conf
build-users-group = nixbld
trusted-users = root fbs
EOF

$ nix-shell -p nixUnstable --command "nix build --experimental-features 'nix-command flakes' '.#homeConfigurations.mac.activationPackage'"
$ ./result/activate
$ home-manager build --flake .#mac
$ home-manager switch --flake .#mac
```

### Upgrading Nix
```
$ nix profile remove 0
$ sudo nix upgrade nix
$ nix-store --gc # garbage collect to remove old packages
$ rm flake.lock
$ # Proceed to reinstall using the above commands
```

## NixOS

`sudo nixos-rebuild switch --flake .`
