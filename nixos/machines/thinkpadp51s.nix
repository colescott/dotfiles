{ config, pkgs, lib, ... }:

{
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        enableCryptodisk = true;
        useOSProber = true;
      };
    };
    
    initrd = {
      luks.devices = [ {
        name = "root";
        device = "/dev/nvme0n1p2";
        preLVM = true;
      } ];
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
    };

    kernelModules = [ "kvm-intel" "thinkpad_acpi" ];
    kernel.sysctl = {
      /* Don't forward ipv4 packets */
      "net.ipv4.ip_forward" = 0;

      /* Swap to disk less */
      "vm.swappiness" = 1;

      /* Power saving */
      "vm.dirty_writeback_centisecs" = 1500;

      /* Disable ipv6 */
      "net.ipv6.conf.all.disable_ipv6" = 1;
      "net.ipv6.conf.default.disable_ipv6" = 1;
      "net.ipv6.conf.lo.disable_ipv6" = 1;
    };
    extraModulePackages = [ ];
  };

  hardware.enableRedistributableFirmware = true; # Allows ilwifi to install

  # Set encrypted volume settings
  swapDevices = [ { device = "/dev/vg/swap"; } ];

  fileSystems."/" = {
    label = "root";
    device = "/dev/vg/root";
    fsType = "btrfs";
    options = ["subvol=nixos"];
  };

  fileSystems."/boot" = {
    device = "/dev/nvme0n1p1";
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

  # Max jobs based on cpu cores
  nix.maxJobs = lib.mkDefault 4;

  # Power settings
  powerManagement = {
    powertop.enable = true;
  };
  services.thinkfan = {
    enable = true;
    sensors = "hwmon /sys/class/hwmon/hwmon3/temp1_input (0, 0, 10)";
  };

}
