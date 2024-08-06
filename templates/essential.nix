{ pkgs }: with pkgs; [
  firefox

  # vscodium
  (vscode-with-extensions.override {
    vscode = vscodium;
    vscodeExtensions = with vscode-extensions; [
      bbenoist.nix
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "dscodegpt";
        publisher = "DanielSanMedium";
        version = "3.4.57";
        hash = "sha256-yBjeUrj/DVTogN6IetwkVKjag9boeb/8SfZo0fG1NkQ=";
      }
      {
        name = "code-spell-checker";
        publisher = "streetsidesoftware";
        version = "4.0.3";
        hash = "sha256-CEGwbw5RpFsfB/g2inScIqWB7/3oxgxz7Yuc6V3OiHg=";
      }
      {
        name = "code-spell-checker-british-english";
        publisher = "streetsidesoftware";
        version = "v1.4.10";
        hash = "sha256-/Ezv6sHAhWy6XujB76tZVR7X5250BDXRQeypV0pqeBg=";
      }
      {
        name = "vscode-mdx";
        publisher = "unifiedjs";
        version = "v1.8.9";
        hash = "sha256-qj8tHc3dtvSFSPUeufvYy+rsa1Gb4tFYemiMDNJlEKg=";
      }
    ];
  })

  pkgs.gnome.gnome-disk-utility
  vlc
  mpv
]
