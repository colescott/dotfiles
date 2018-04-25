{ config, pkgs, ... }:

{
  # Use the gummiboot efi boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Basic kernel modules
  boot.initrd.kernelModules = [ "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" ];
  
  # Crypto setup modules
  boot.initrd.luks.cryptoModules = [ "aes" "xts" "sha512" ];
  
  # Enable YubiKey PBA support
  boot.initrd.luks.yubikeySupport = true;
  # Configuration for luks device
  boot.initrd.luks.devices = [ {
    name = "luksroot";
    device = "/dev/nvme0n1p2";
    preLVM = true;
    yubikey = {
      storage = {
        device = "/dev/nvme0n1p1";
      };
    };
  } ];

  # Set encrypted volume settings
  swapDevices = [ { device = "/dev/luks-vg/swap"; } ];

  # Latest and greatest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  fileSystems."/" = {
    label = "root";
    device = "/dev/luks-vg/root";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C54B-A107";
    fsType = "vfat";
  };

  fileSystems."/mnt/D❤ddy" = {
    device = "/dev/disk/by-uuid/b5c7a574-9f3a-40d1-bfbd-e954f60ada68";
    fsType = "ext4";
    neededForBoot = false;
    options = ["defaults" "noatime" "user"];
  };

  networking.hostName = "cole-nixos-thinkpad"; # Define hostname.

  services.xserver.synaptics = {
    enable = true;
    vertTwoFingerScroll = true;
    vertEdgeScroll = false;
    palmDetect = true;
  };
}
