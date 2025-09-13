{ pkgs, unstable }: with pkgs; [
  # versioning
  git

  # browser
  ungoogled-chromium

  # scripting...
  python313
  python313Packages.opencv4
  gtk2 #for cv2
  qt5.full

  # android studio
  pkgs.android-studio
  android-tools

  # vscodium
  vscode.fhs

  # microcontroller
  arduino-ide

  # unstable.godot_4-mono
  unstable.godot_4

  # node
  nodejs
  yarn

  # java
  jetbrains.idea-community-bin
  maven
  libvlc
  jdk
]
