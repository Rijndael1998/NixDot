{ pkgs, unstable }: with pkgs; [
  neofetch
  (pkgs.callPackage ../custom-packages/blender.nix { })

  # Exercism
  pkgs.exercism

  # Required for kden
  glaxnimate
  libsForQt5.kdenlive
  kdePackages.kdenlive

  # 🏴‍☠️
  transmission_4-qt

  # 3d printing
  orca-slicer

  # epic games
  (heroic.override {
    extraPkgs = pkgs: [
      pkgs.gamescope
    ];
  })

  # minecraft
  prismlauncher

  #cad
  openscad
  kicad
  arduino-ide
]
