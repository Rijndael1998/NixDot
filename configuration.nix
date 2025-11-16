{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
  rPackages = import ./r.nix { inherit pkgs; inherit unstable; }; # Import user's specific package list
  hostname = import ./hostname.nix { };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Include custom hardware
      ./custom-hardware.nix
      # musnix
      <musnix>
    ];

  nixpkgs.overlays = 
    [ 
      (import ./overlays/esp/overlay.nix)
    ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  nix.settings.experimental-features =
    [
      "nix-command"
      "flakes"
    ];

  # dvb/tv
  hardware.rtl-sdr.enable = true;

  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld;
  };

  hardware.sane.enable = true; # enables support for SANE scanners

  # node red
  services.node-red.enable = true;

  # ssh
  services.openssh.enable = true;
  services.openssh.settings.X11Forwarding = true;

  # suid wrappers
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # open rgb (oooo, pretty lights)
  services.hardware.openrgb.enable = true;
  services.hardware.openrgb.package = unstable.openrgb-with-all-plugins;

  # piper
  services.ratbagd.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.memtest86.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = ["ecryptfs"];

  # boot options
  boot.supportedFilesystems = [ "ntfs" ]; # add ntfs support

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };
  
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  # environment.plasma6.excludePackages = [ pkgs.kdePackages.dolphin ]; # we will get this from latest
  programs.kdeconnect.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # setting up our prints
  services.printing.drivers = [
    pkgs.gutenprint
    pkgs.gutenprintBin
    pkgs.canon-capt
  ];

  # sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  musnix.enable = true;

  # Enable steam / games
  programs.steam.enable = true;
  programs.gamescope.enable = true;
  programs.gamemode.enable = true;

  users.users = {
    r = (import ./lambdas/user/normal.nix) {
      pkgs = pkgs;
      desc = "Rin";
      pack = rPackages;
      admin = true;
    };
    alifeee = (import ./lambdas/user/normal.nix) {
      pkgs = pkgs;
      desc = "Alifeee";
      pack = rPackages;
      admin = true;
    };
  };

  # https://nixos.wiki/wiki/ECryptfs
  security.pam.enableEcryptfs = true;

  # docker
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # root utils
  users.users.root = {
    packages = with pkgs; [
      lshw
      pciutils
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # kde
    kdePackages.kdialog
    unstable.kdePackages.dolphin

    # basics for web
    wget
    git
    unstable.lynx

    # lsusb and stuff
    usbutils
    v4l-utils

    # partitioning
    parted
    gparted
    pkgs.ntfs3g

    # pretty lights & mouse software
    piper

    # utils
    pv
    pigz
    screen
    bc
    file
    jq

    # ffmpeg
    ffmpeg_7-full
    libGL
    openh264
    x264

    # video download helper
    vdhcoapp

    # Spelling
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science

    # mining
    unstable.xmrig

    # others
    p7zip
    wineWowPackages.waylandFull

    # opencl
    clinfo

    # sdr/tv/dvb
    pkgs.rtl-sdr
    gqrx

    # home folder security
    ecryptfs

    # dvd
    kdePackages.k3b # dvd burner
    cdrtools
    cdrdao
    dvdplusrwtools
  ];

  # espurino
  services.udev.extraRules = ''
ATTRS{idProduct}=="5740", ATTRS{idVendor}=="0483", ENV{ID_MM_DEVICE_IGNORE}="1", MODE="0666", GROUP="plugdev"
ATTRS{idProduct}=="1015", ATTRS{idVendor}=="1366", ENV{ID_MM_DEVICE_IGNORE}="1", MODE="0666", GROUP="plugdev"
ATTRS{idProduct}=="520f", ATTRS{idVendor}=="1915", ENV{ID_MM_DEVICE_IGNORE}="1", MODE="0666", GROUP="plugdev"
ATTRS{idProduct}=="0204", ATTRS{idVendor}=="0d28", ENV{ID_MM_DEVICE_IGNORE}="1", MODE="0666", GROUP="plugdev"
  '';

  # virtbox
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # virtualbox
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ 
    "r"
    "root"
  ];

  # waydroid / android
  virtualisation.waydroid.enable = true;
  
  # Git
  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  # for k3b
  security.wrappers = {
    cdrdao = {
      setuid = true;
      owner = "root";
      group = "cdrom";
      permissions = "u+wrx,g+x";
      source = "${pkgs.cdrdao}/bin/cdrdao";
    };
    cdrecord = {
      setuid = true;
      owner = "root";
      group = "cdrom";
      permissions = "u+wrx,g+x";
      source = "${pkgs.cdrtools}/bin/cdrecord";
    };
  };

  # enable local ai
  services.ollama.enable = true;

  # let users have their cron
  services.cron.enable = true;

  # mullvad vpn
  services.mullvad-vpn.enable = true;

  # setting this to true makes it possible to fix systems without the net
  system.includeBuildDependencies = false;

  # Networking
  networking.hostName = hostname;

  # Enable networking
  networking.networkmanager.enable = true;

  # Open ports in the firewall.
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [
    # http
    80

    # node
    3000
    3001

    # ssh
    22
  ];

  networking.firewall.allowedUDPPorts = [
  ];

  networking.firewall.allowedTCPPortRanges = [
    { # kdeconnect
      from = 1714;
      to = 1764;
    }
  ];

  networking.firewall.allowedUDPPortRanges = [
    { # kdeconnect
      from = 1714;
      to = 1764;
    }
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment? YES!
}
