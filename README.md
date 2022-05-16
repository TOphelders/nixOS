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

## NixOS

`sudo nixos-rebuild switch --flake .`
