{ config, pkgs, ... }:

{
  # Use the gummiboot efi boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.device = "/dev/sda";

  # Set encrypted volume settings
  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/sda6";
      preLVM = true;
    }
  ];

  networking.hostName = "cole-nixos"; # Define hostname.

  services.xserver.videoDrivers = [ "nvidia" ];
}
