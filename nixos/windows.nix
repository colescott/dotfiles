{ pkgs, config, ...}:

{
  virtualisation.libvirtd = {
    enable = true;
    qemuPackage = pkgs.qemu_kvm;
  };

  # Enable IGVT passthrough
  virtualisation.kvmgt = {
    enable = false;#true;
    vgpus = {
      "i915-GVTg_V5_8" = {
        uuid = [ "a8717bb8-f624-11ea-96e6-482ae377b3d3" ];
      };
    };
  };
  virtualisation.spiceUSBRedirection.enable = true;

  environment.systemPackages = with pkgs; [
    virt-manager
  ];
}
