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

  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld;
  };

  hardware.sane.enable = true; # enables support for SANE scanners

  services.syncthing = {
    enable = true;
    group = "users";
    user = "r";
    dataDir = "/home/r/.syncthing";    # Default folder for new synced folders
    configDir = "/home/r/.syncthing";   # Folder for Syncthing's settings and keys
  };

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

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.memtest86.enable = true;
  boot.kernelPackages = unstable.linuxPackages_latest;

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

  # Enable the XFCE Desktop Environment.
  nixpkgs.config.pulseaudio = true;

  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
  };

  services.displayManager.defaultSession = "xfce";

  programs.kdeconnect.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.r = {
    isNormalUser = true;
    description = "Rin";
    extraGroups = [ 
      "networkmanager"
      "wheel"
      "plugdev"
      "uucp"
      "lock"
      "libvirtd"
      "docker"
      "scanner"
      "lp"
      "dialout"
      "render"
      "audio"
      "cdrom"
     ];
    packages = rPackages;
  };

  # root utils
  users.users.root = {
    packages = with pkgs; [
      lshw
      pciutils
    ];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "r";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # dialog box access for kde
    kdePackages.kdialog

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
  
    # gpu control
    lact
  ];

  # lact
  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = ["multi-user.target"];

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

  # waydroid / android
  virtualisation.waydroid.enable = true;

  # Docker
  virtualisation.docker.enable = true;
  
  # Git
  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  # Networking
  networking.hostName = hostname;

  # Enable networking
  networking.networkmanager.enable = true;

  # Open ports in the firewall.
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [
  ];

  networking.firewall.allowedUDPPorts = [
  ];

  networking.firewall.allowedTCPPortRanges = [
  ];

  networking.firewall.allowedUDPPortRanges = [
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.04"; # Did you read the comment? YES!
}
