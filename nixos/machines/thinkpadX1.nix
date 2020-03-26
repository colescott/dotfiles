{ config, lib, pkgs, ... }:

{
  networking.hostId = "68704184";
  networking.hostName = "thonkpod";

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.kernelPackages = pkgs.linuxPackages_latest; # pkgs.linuxPackages_5_3;

  hardware.cpu.intel.updateMicrocode = true; # Since we seem to need them so often

  hardware.enableRedistributableFirmware = true; # Needed for iwlwifi

  boot.initrd.luks.devices."enc-boot" = {
    device = "/dev/disk/by-uuid/1cb10647-9eec-462d-ba01-f5325b779837";
    keyFile = "/keyfile.bin";
    fallbackToPassword = true;
  };

  boot.initrd.luks.devices."enc-root" = {
    device = "/dev/disk/by-uuid/91950a65-a963-4274-8da9-1f2fb57f0834";
    keyFile = "/keyfile.bin";
  };
  boot.initrd.luks.devices."enc-swap" = {
    device = "/dev/disk/by-uuid/d7ca8fe7-c75a-4f09-a2e9-d856670f82de";
    keyFile = "/keyfile.bin";
  };

  fileSystems."/" =
    { device = "zroot/root";
      fsType = "zfs";
    };

  fileSystems."/efi" =
    { device = "/dev/disk/by-uuid/CA04-D731";
      fsType = "vfat";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/1e1b22fe-5318-4981-bed7-4521bf458c63";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/cb7f09cb-b2fb-49bd-92c5-860856a67e24"; }
    ];

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/efi";
    };
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      version = 2;
      extraInitrd = "/boot/initrd.keys.gz";
      enableCryptodisk = true;
    };
  };

  # Fingerprints
  services.fprintd.enable = true;
  security.pam.services.login.fprintAuth = true;
  services.fwupd.enable = true;

  nix.maxJobs = lib.mkDefault 12;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
