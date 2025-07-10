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

  services.syncthing = {
    enable = true;
    group = "users";
    user = "r";
    dataDir = "/home/r/.syncthing";    # Default folder for new synced folders
    configDir = "/home/r/.syncthing";   # Folder for Syncthing's settings and keys
  };

  # tor node
  services.tor = {
    enableGeoIP = true;

    settings = {
      Address = "baldy.ga";

      ContactInfo = "c3ypt1c@gmail.com";

      # HashedControlPassword 16:9958340DF0B50ED0606F3EA86CE7C4B6D40B1991ED01A26CD92C8358A4
      ORPort = 25565;
      DirPort = 25566;
      ControlPort = [ { port = 9051; } ];

      RelayBandwidthRate = "25000 KBytes";
      RelayBandwidthBurst = "25000 KBytes";
    };
    
    relay = {
      enable = false;
      role = "relay";
    };
  };

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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

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
     ];
    packages = rPackages;
  };

  # guest tools
  services.xe-guest-utilities.enable = true;

  # docker
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

    # pretty lights & mouse software
    piper

    # utils
    pv
    pigz
    screen
    bc

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
  ];

  # virtbox
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Docker
  virtualisation.docker.enable = true;
  
  # Git
  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  # mining
  services.xmrig = {
    enable = true; 
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
  systemd.services.xmrig.enable = false; # i start and stop this when i please

  # setting this to true makes it possible to fix systems without the net
  system.includeBuildDependencies = false;

  # Networking
  networking.hostName = hostname;

  # Enable networking
  networking.networkmanager.enable = true;

  # Open ports in the firewall.
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [
    # ssh
    22

    # asf
    1242
  ];

  networking.firewall.allowedUDPPorts = [
    80
    443

    # asf
    1242
  ];

  # configure nginx
  services.nginx.enable = true;
  services.nginx.virtualHosts = builtins.listToAttrs (
    (map 
      (import ./lambdas/nginx/indexed.nix) [
        "baldy.ga"
        "lukasz.baldy.ga"
        "next.baldy.ga"
        "security.baldy.ga"
        "www.baldy.ga"
      ]
    )
    ++
    (map # only add ssh support
      (import ./lambdas/nginx/acme.nix) [
        "testing.baldy.ga"
      ]
    )
    ++
    (map
      (import ./lambdas/nginx/reverse.nix) [
        {
          domain = "ha.baldy.ga";
          proxyURL = "http://homeassistant.lan:8123/";
        }
      ]
    )
    ++
    (map
      (import ./lambdas/nginx/reverse_with_ssl.nix) [
        {
          domain = "rijn.dev";
          proxyURL = "http://localhost/";
          key = "rijn.dev";
        }
        {
          domain = "html.rijn.dev";
          proxyURL = "http://localhost/";
          key = "rijn.dev";
        }
        {
          domain = "xoa.rijn.dev";
          proxyURL = "https://xoa.lan/";
          extraLoc = ''
            proxy_ssl_verify off;
          '';
          key = "rijn.dev";
        }
        { # rijn.pl
          domain = "rijn.pl";
          proxyURL = "http://localhost/";
          key = "rijn.pl";
        }
      ]
    )
    ++
    (map
      (import ./lambdas/nginx/reverse_with_headers.nix) [
        {
          domain = "xoa.baldy.ga";
          proxyURL = "https://xoa.lan/";
          extraLoc = ''
            proxy_ssl_verify off;
          '';
        }
        {
          domain = "matilda-gifts.shop";
          proxyURL = "http://portainer.lan:8080/";
        }
      ]
    )
    ++ 
    [{
      name = "localhost";
      value = {
        root = "/var/www/html";
        extraConfig = ''
            autoindex on;
            autoindex_exact_size off;
            autoindex_format html;
            autoindex_localtime on;
        '';
      };
    }]
  );

  # acme
  security.acme.defaults.email = "acme@baldy.ga";
  security.acme.acceptTerms = true;

  # pastebin
  services.privatebin.virtualHost = "testing.baldy.ga";
  services.privatebin.enable = true;
  services.privatebin.enableNginx = true;

  # mysql
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  # asf
  services.archisteamfarm.enable = true;
  services.archisteamfarm.web-ui.enable = true;
  services.archisteamfarm.ipcSettings = {
    Kestrel = {
      Endpoints = {
        HTTP = {
          Url = "http://*:1242";
        };
      };
    };
  };
  services.archisteamfarm.ipcPasswordFile = "/etc/keys/asf/ipcpwd";


  systemd.timers."auto-update" = {
  wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true; 
      Unit = "auto-update.service";
    };
  };

  systemd.services."auto-update" = {
    script = ''
      set -e

      /etc/nixos/scripts/cleanAndPull.sh

      nix-channel --update
      nixos-rebuild switch

    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment? YES!
}
