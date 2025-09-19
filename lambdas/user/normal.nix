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
    "cdrom"
    ] ++ pkgs.lib.optionals (admin) [
    "wheel"
    ];
  packages = pack;
  initialPassword = "strawberry";
}