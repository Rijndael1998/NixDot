{ pkgs, unstable }: with pkgs; [
  mc
  unstable.openrgb-with-all-plugins
  lm_sensors
  htop
  btop
  # ventoy-full is marked as insecure
  kdePackages.filelight
  kdePackages.k3b # dvd burner
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
  parallel
]
