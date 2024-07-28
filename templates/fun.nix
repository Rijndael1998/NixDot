{ pkgs }: with pkgs; [
  neofetch
  (pkgs.callPackage ../custom-packages/blender.nix { })

  # Exercism
  pkgs.exercism

  # Required for kden
  glaxnimate
  libsForQt5.kdenlive
  kdePackages.kdenlive

  # 🏴‍☠️
  transmission-qt
]
