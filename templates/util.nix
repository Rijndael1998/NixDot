{ pkgs, unstable }: with pkgs; [
  mc
  (pkgs.callPackage ../custom-packages/openrgb.nix {})
  lm_sensors
  htop
  btop
  # ventoy-full is marked as insecure
  kdePackages.filelight
  killall
  clinfo
  dig
  pwvucontrol
  helvum
  unstable.handbrake
  unstable.czkawka-full
  exiftool
  unstable.digikam
  tor-browser
]
