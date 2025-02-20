# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/4549521d-35cb-45da-aff8-5c63c56a21b2";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-daeb1cc4-8a25-45fd-9714-f6f908f470f9".device = "/dev/disk/by-uuid/daeb1cc4-8a25-45fd-9714-f6f908f470f9";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/6654-235C";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [ ];
  environment.etc.crypttab = {
    mode = "0600";
    text = ''
      #
      cryptstorage UUID=f366d91b-955d-4527-9f1b-d7f913c48260 /root/keys/2tb_toaster.key nofail
      cryptstorage UUID=f20e3e7c-c606-409f-b68a-93f0d4e33b6a /root/keys/2tb_external.key nofail
    '';
  };

  swapDevices = [ 
#    "/swapfile"
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
