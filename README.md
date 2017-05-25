# dotfiles
All my config files in one place =D

## How to install
1. Run `install.sh`
2. Copy `hardware-configuration.nix` from the backups folder to nixos folder
3. Copy the contents of `openssl passwd -1` to passwords/username
4. Run `nixos-rebuild switch`
5. Relax

## How to remove
1. Attempt to remove manually 
2. Run into hundreds of problems
3. Give up and cry

## Permission issues
If you run into any permission issues, run `fix-permissions.sh`
