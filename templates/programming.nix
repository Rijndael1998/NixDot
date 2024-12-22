{ pkgs }: with pkgs; [
  # versioning
  git

  # browser
  ungoogled-chromium

  # scripting...
  python3

  # android studio
  pkgs.android-studio

  # gay vscodium
  vscode.fhs
]
