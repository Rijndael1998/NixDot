hardware.bluetooth.enable = true; # enables support for Bluetooth
hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

# Custom hardware (nvidia)
services.xserver.videoDrivers = [ "nvidia" ];
#hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;
hardware.nvidia.prime = {
  # Sync Mode [Optimus PRIME Option B: Sync Mode](https://nixos.wiki/wiki/Nvidia) 
  sync.enable = true;

#  reverseSync.enable = true;
  allowExternalGpu = true;

  # Make sure to use the correct Bus ID values for your system!
  #intelBusId = "PCI:0:2:0";
  amdgpuBusId = "PCI:7:0:0";
  nvidiaBusId = "PCI:1:0:0";
};
