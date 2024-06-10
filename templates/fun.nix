{ pkgs }: with pkgs; [
  neofetch
  blender

  # Exercism
  pkgs.exercism

  # Required for kden
  glaxnimate
  libsForQt5.kdenlive
  kdePackages.kdenlive
]
