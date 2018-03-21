{ pkgs, ... }:

{
  nix.nixPath = pkgs.lib.mkBefore [ "/nix/var/nix/profiles/per-user/cole/channels/nixpkgs" ];
  
  allowUnfree = true;
  allowBroken = true;

  permittedInsecurePackages = [
    "linux-4.13.16"
  ];
  
  packageOverrides = pkgs: rec {
    home-manager = import ./home-manager { inherit pkgs; };
  };
}
