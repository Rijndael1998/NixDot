{ config, lib, pkgs, modulesPath,  ... }:

{
  config.hardware.bluetooth.enable = true; # enables support for Bluetooth
  config.hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  # Custom hardware (nvidia)
  config.services.xserver.videoDrivers = [ "nvidia" ];
  #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;
  config.hardware.nvidia.prime = {
    # Sync Mode [Optimus PRIME Option B: Sync Mode](https://nixos.wiki/wiki/Nvidia) 
    sync.enable = true;

    #reverseSync.enable = true;
    allowExternalGpu = true;

    # Make sure to use the correct Bus ID values for your system!
    #intelBusId = "PCI:0:2:0";
    amdgpuBusId = "PCI:7:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  config.hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # make sure my 100mb partition doesn't get clogged
  config.boot.loader.grub.configurationLimit = 10;

  # ollama 
  config.services.ollama.acceleration = "cuda"; 
}
