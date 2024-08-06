{ pkgs }: with pkgs; [
  firefox

  # vscodium
  (vscode-with-extensions.override {
    vscode = vscodium;
    vscodeExtensions = with vscode-extensions; [
      bbenoist.nix
      ms-python.python
      ms-azuretools.vscode-docker
      ms-vscode-remote.remote-ssh
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "dscodegpt";
        publisher = "DanielSanMedium";
        version = "3.4.10";
        hash = "sha256-zjaM9YME0wfBOwhJTacnQbQvw35QL5NvXIBAx5d/bjI=";
      }
    ];
  })

  pkgs.gnome.gnome-disk-utility
  vlc
  mpv
]
