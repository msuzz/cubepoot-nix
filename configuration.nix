# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, nix-matlab, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./syncthing.nix
    ];

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelParams = [ */ list of command line arguments */ ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.supportedFilesystems = [ "ntfs "];
  boot.kernelModules = [ "kvm-amd" "k10temp" "i2c-dev" "sg" ];
  boot.kernel.sysctl = { "vm.max_map_count" = 1048576; };
  boot.extraModulePackages = with config.boot.kernelPackages; [
    rtl8814au
  ];
  
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "cubepoot"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Australia/Sydney";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  # networking.useDHCP = false;
  # networking.interfaces.enp4s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Graphics
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
    
  ];

  # X11 Windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.gnome.gnome-keyring.enable = true;
  environment.gnome.excludePackages = with pkgs; [
    gnome.cheese
    gnome.gnome-music
    gnome.totem
    gnome.geary
    gnome-tour
  ];

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.openFirewall = true;
  #services.printing.drivers = [ pkgs.hplip ];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = false; # Disable due to PipeWire

  # Enable PipeWire  
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # Warning: Arrays are replaced rather than merged with defaults, so in
    # order to keep default items in the configuration, they have to be listed    
    # No longer has any effect as of 29/3/23
    #config.pipewire = {
    #  "context.properties" = {
    #    "default.clock.rate" = 41000;
    #  };
    #};
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Enable Docker in rootless mode
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
    rootless = {
      enable = true;
      setSocketVariable = true; 
    };
  };

  # KVM
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.michael = {
    isNormalUser = true;
    extraGroups = [ "wheel" "adbusers" "libvirtd" "networkmanager" "cdrom" ];
    shell = pkgs.fish;
  };

  #nixpkgs.config.packageOverrides = pkgs: {
  #  my_mathematica = pkgs.mathematica.override {
  #    source = pkgs.requireFile {
  #      name = "Mathematica_13.0.1_BNDL_LINUX.sh";
  #      sha256 = "sha256:0v61kf5xc18frjppwy9qq0m6s4930d587nw0pkpxxq3d82c5c1zw";
  #      message = ''
  #        Your override for Mathematica includes a different src for the installer,
  #        and it is missing.
  #      '';
  #      hashMode = "recursive";
  #    };
  #  };
  #};

  # Proper Blu-ray support
  nixpkgs.overlays = [
    (
      self: super: {
        libbluray = super.libbluray.override {
          withAACS = true;
          withBDplus = true;
        };
      }
    )
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    nix-matlab.defaultPackage.${pkgs.system}
    vim
    neovim
    emacs28NativeComp
    tmux
    btrfs-progs
    ntfs3g
    fzf
    htop
    stow
    git
    openssh
    wget
    guake
    lm_sensors
    liquidctl
    usbutils
    gnome.gnome-tweaks
    libsForQt5.qtstyleplugins
    rsync
    grsync
    syncthing
    keepassxc
    unar
    mpv
    libbluray
    falkon
    firefox-wayland
    thunderbird
    libreoffice
    qbittorrent
    deadbeef-with-plugins
    discord
    zoom-us
    okular
    steam-run
    protontricks
    protonup
    mangohud
    retroarch
    minigalaxy
    calibre
    gimp-with-plugins
    libsForQt5.kdenlive
    libsForQt5.k3b
    blender
    #my_mathematica
    texmacs
    kicad
    texlive.combined.scheme-small
    ghidra
    vscode.fhs
    wineWowPackages.stagingFull
    winetricks
    dxvk
    python311Full
    perl
    jdk
    vkquake
    gzdoom
    enyo-doom
    ecwolf
    eduke32
    dosbox-staging
    corectrl
    virt-manager
    direnv
  ];

  # Fonts
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      iosevka-bin
      fantasque-sans-mono
      source-sans
      source-serif
      courier-prime
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Source Serif 4 Regular" ];
        sansSerif = [ "Source Sans 3 Regular" ];
        monospace = [ "Iosevka Regular" ];
      };
    };
  };

  # Global environment variables
  environment.variables = {
    EDITOR = "vim";
    SUDO_EDITOR = "vim";
    QT_QPA_PLATFORMTHEME = "gnome";
  };

  # Session env vars
  environment.sessionVariables = rec {
    XDG_CACHE_HOME  = "\${HOME}/.cache";
    XDG_CONFIG_HOME = "\${HOME}/.config";
    XDG_BIN_HOME    = "\${HOME}/.local/bin";
    XDG_DATA_HOME   = "\${HOME}/.local/share";
    PATH = [ 
      "\${XDG_BIN_HOME}"
    ];
    MOZ_ENABLE_WAYLAND = "1";
    # https://bugzilla.mozilla.org/show_bug.cgi?id=1751363
    #MOZ_DISABLE_RDD_SANDBOX = "1";
    NIXOS_OZONE_WL = "1";
  };

  # Enable programs
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.fish.enable = true;
  programs.steam.enable = true;
  programs.adb.enable = true;

  # List services that you want to enable:
  services.openssh = {
    enable = true;
  };
  services.udev.packages = [ pkgs.liquidctl ];
  # services.flatpak.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Nix settings
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nix.settings.auto-optimise-store = true;
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Copy this configuration to /run/current-system/configuration.nix
  # incase I accidentally rm it (again)
  #system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

