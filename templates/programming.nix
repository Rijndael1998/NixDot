{ pkgs, unstable }: with pkgs; [
  # versioning
  git

  # browser
  ungoogled-chromium

  # scripting...
  python312Full
  python312Packages.opencv4
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
]
