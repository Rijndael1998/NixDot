{ config, lib, pkgs, modulesPath, ... }:
{ 
  config.services.ollama.acceleration = "rocm"; 

  # Enable openGL and install Rocm
  config.hardware.graphics = {
    enable = true;
    #driSupport = true;
    #driSupport32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      rocmPackages.clr
      rocmPackages.rocminfo
      rocmPackages.rocm-runtime
    ];
  };
}
