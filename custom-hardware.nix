{ config, lib, pkgs, modulesPath, ... }:
{ 
  config.services.ollama.acceleration = "rocm"; 
}
