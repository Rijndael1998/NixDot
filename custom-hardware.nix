{ config, lib, pkgs, modulesPath, ... }:
{ 
  config.services.ollama.acceleration = "rocm"; 

  # Enable openGL and install Rocm
  config.hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      rocmPackages.clr
      rocmPackages.rocminfo
      rocmPackages.rocm-runtime

      # used for vaapi
      libva
    ];
  };
}
