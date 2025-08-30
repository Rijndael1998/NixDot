{ pkgs, desc, pack, admin } : {
  isNormalUser = true;
  description = desc;
  extraGroups = [ 
    "networkmanager"
    "plugdev"
    "uucp"
    "lock"
    "libvirtd"
    "docker"
    "scanner"
    "lp"
    "dialout"
    "render"
    "audio"
    ] ++ pkgs.lib.optionals (admin) [
    "wheel"
    ];
  packages = pack;
  initialPassword = "strawberry";
}