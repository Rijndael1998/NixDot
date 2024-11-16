# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
let
  # Import user's specific package list
  rPackages = import ./r.nix { inherit pkgs; inherit unstable; };
  hostname = import ./hostname.nix { };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Include custom hardware
      ./custom-hardware.nix
    ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

#  services.klipper = {
#    enable = true;
#    
#  };

  hardware.sane.enable = true; # enables support for SANE scanners

  # ssh
  services.openssh.enable = true;
  services.openssh.settings.X11Forwarding = true;

  # open rgb (oooo, pretty lights)
  services.hardware.openrgb.enable = true;

  # piper
  services.ratbagd.enable = true;

  # cpu temps
  services.auto-cpufreq.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # boot options
  boot.supportedFilesystems = [ "ntfs" ]; # add ntfs support

  networking.hostName = hostname; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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

  services.printing.drivers = [
    pkgs.gutenprint
    pkgs.gutenprintBin
    pkgs.canon-capt
  ];

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable steam
  programs.steam.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

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
     ];
    packages = rPackages;
  };

  # guest profile
  users.users.guest = {
    isNormalUser = true;
    description = "Guest Profile";
    extraGroups = [ 
      "networkmanager"
      "lp" # printer
     ];
    packages = rPackages;
  };

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
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget

    pkgs.veracrypt

    pkgs.gamemode

    # dialog box access for kde
    kdePackages.kdialog

    # basics for web
    git
    nodejs
    yarn

    # lsusb and stuff
    usbutils
    v4l-utils

    # partitioning
    parted
    gparted
    pkgs.ntfs3g

    # pretty lights & mouse software
    piper
    openrgb-with-all-plugins

    # utils
    pv
    pigz

    ffmpeg_7-full
    libGL

    vdhcoapp

    android-tools

    # Spelling
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science

    # godot
    godot_4

    # mining
    unstable.xmrig

    # Zero trust
    unstable.netbird-ui

    # others
    p7zip
    wineWowPackages.waylandFull

    # opencl
    clinfo

    openh264
    x264
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

  # bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth

  # Docker
  virtualisation.docker.enable = true;
  
  # Git
  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  # enable local ai
  services.ollama.enable = true;

  # mining
  services.xmrig = {
    enable = true; # i start and stop this when i please
    package = unstable.xmrig;
    settings = {
      autosave = true;
      cpu = true;
      opencl = false;
      cuda = false;
      pools = [{
        url = "baldy.ga";
      }];
    };
  };

  # making it possible to unfuck my system offline
  system.includeBuildDependencies = true;

  # netbird
  services.netbird.enable = true;
  services.netbird.package = unstable.netbird;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 80 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
