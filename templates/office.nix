{ pkgs, unstable }: with pkgs; [
  pkgs.libreoffice-fresh
  unstable.joplin-desktop
  (pkgs.wrapOBS {
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi
      obs-3d-effect
    ];
  })
  pkgs.gimp
]
