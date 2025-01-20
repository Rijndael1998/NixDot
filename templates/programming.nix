{ pkgs }: with pkgs; [
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

  # vscodium
  vscode.fhs

  godot_4-mono
]
