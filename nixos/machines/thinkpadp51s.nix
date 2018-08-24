{ config, pkgs, ... }:

{
  # Use the gummiboot efi boot loader.
  boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;

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

  fileSystems."/" = {
    label = "root";
    device = "/dev/luks-vg/root";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C54B-A107";
    fsType = "vfat";
  };

  fileSystems."/mnt/ext5" = {
    device = "/dev/disk/by-uuid/F6BA35F3BA35B14B";
    fsType = "ntfs";
    neededForBoot = false;
    options = ["defaults" "noatime" "user" "nofail"];
  };

  networking.hostName = "cole-nixos-thinkpad";

  services.xserver.synaptics = {
    enable = true;
    vertTwoFingerScroll = true;
    vertEdgeScroll = false;
    palmDetect = true;
  };
}
