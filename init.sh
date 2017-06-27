cd $(dirname $0)

git submodule init
git submodule update
git update-index --assume-unchanged nixos/machine-configuration.nix

echo "Done!"
