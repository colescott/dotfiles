# dotfiles
All my configs for my nixos machine in one repo, all written with nix.

## How to install
1. Run `make install` as root
2. Pipe the contents of `openssl passwd -1` to passwords/username
3. Uncomment line in `machine-configuration.nix` to enable machine config
4. Run `nixos-rebuild switch`
