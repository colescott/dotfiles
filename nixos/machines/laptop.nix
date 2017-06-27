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
      device = "/dev/sda4";
      preLVM = true;
    }
  ];

  networking.hostName = "cole-nixos-laptop"; # Define hostname.

  services.xserver.synaptics = {
    enable = true;
    vertTwoFingerScroll = true;
    vertEdgeScroll = false;
    palmDetect = true;
  };

  #environment.systemPackages += with pkgs; [
  #  xorg.xbacklight
  #];
}
