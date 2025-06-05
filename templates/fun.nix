{ pkgs, unstable }: with pkgs; [
  neofetch
  
  # pure hip blender
  unstable.blender-hip

  # splats
  colmap
  opensplat

  # Exercism
  pkgs.exercism

  # Required for kden
  glaxnimate
  libsForQt5.kdenlive
  kdePackages.kdenlive

  # 🏴‍☠️
  transmission_4-qt

  # mullvad suite
  mullvad
  mullvad-vpn
  mullvad-browser

  # 3d printing
  orca-slicer
  prusa-slicer

  # games
  pkgs.gamemode

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
]
