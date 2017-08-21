{ pkgs, ... }:

{
  nix.nixPath = pkgs.lib.mkBefore [ "/nix/var/nix/profiles/per-user/cole/channels/nixpkgs" ];
  
  allowUnfree = true;
  allowBroken = true;

  packageOverrides = pkgs: rec {
    home-manager = import ./home-manager { inherit pkgs; };
  };
}
