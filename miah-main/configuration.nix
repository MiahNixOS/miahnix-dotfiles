# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #./hosts/main/sys/mounts.nix
      ./cloudflared.nix
      ./samba.nix
      ./nixvim.nix
      ./miah-docker.nix
      ./ai.nix
    ];

    services.udisks2.enable = true;

  # Bootloader.
    boot.kernelModules = [ "kvm-amd" ];
    programs.virt-manager.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
    virtualisation.libvirtd = {
        enable = true;
        qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
    };

    hardware.logitech.wireless.enable = true;
    services.blueman.enable = true;

    # programs.logiops.enable = true;

  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
  	enable = true;
  	useOSProber = true;
	  efiSupport = true;
	  devices = [ "nodev" ];
  };

  boot.loader.efi.canTouchEfiVariables = true;

  #boot.kernelPackages = pkgs.linuxPackages_latest;

  #hardware.graphics.enable = true;

  # services.xserver.videoDrivers = ["nvidia"];
  #
  # hardware.nvidia = {
  #   enable = true;
  #   modesetting.enable = true;
  #   open = false;
  #   package = config.boot.kernelPackages.nvidiaPackages.beta;
  # };
  #
  # # Use latest kernel.
  # #boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelParams = [ "nvidia-drm.fbdev=1" ];
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    forceFullCompositionPipeline = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
 
   # Enable XDG desktop portals
  xdg.portal = {
  	enable = true;
	wlr.enable = true;
  };

 # programs.obs-studio = {
 #    enable = true;
 # 
 #    package = (
 #      pkgs.obs-studio.override {
 #        cudaSupport = true;
 #      }
 #    );
 # 
 #    plugins = with pkgs.obs-studio-plugins; [
 #      wlrobs
 #      obs-pipewire-audio-capture
 #      obs-vaapi
 #      obs-gstreamer
 #      obs-vkcapture
 #    ];
 #  };
  
  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  services.gvfs.enable = true;

  environment.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
  };
  services.samba.enable = true;
  services.avahi.enable = true;
  services.tumbler.enable = true;



  # PostgreSQL
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_18; # Use this line
    # ... other settings
  };

  #xdg.portal.extraPortals = with pkgs; [
  #  xdg-desktop-portal-wlr # Essential for wlroots-based compositors like MangoWC
  #];
  # You might need to disable other portals if they cause conflicts
  # xdg.portal.extraPortals = with pkgs; [ ]; # Example if you need to clear defaults first
  #xdg.portal.wlr.enable = true; # Specific setting for the wlr portal

  #programs.pkgs.noctalia-shell.enable = true;

  networking.hostName = "miahnix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.cloudflared.enable = true;
  services.nginx.enable = true;
  services.nginx.virtualHosts."localhost" = {
    root = "/var/www/html"; # Or your chosen root directory
  };


  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  programs.hyprland = {
  	enable = true;
	xwayland.enable = true;
  };
  programs.mango = {
  	enable = true;
	#xwayland.enable = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Use fish shell - ArchGodot
  programs.fish.enable = true;
  environment.shells = with pkgs; [ fish ];


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.archgodot = {
    isNormalUser = true;
    description = "ArchGodot";
    extraGroups = [ "docker" "networkmanager" "wheel" "libvirtd" ];

    shell = pkgs.fish;

    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  services.open-webui.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    (wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vaapi #optional AMD hardware acceleration
        obs-gstreamer
        obs-vkcapture
      ];
    })
    vim
    tmux
    #neovim
    bat
    btop
    neofetch
    # obs-studio
    cmatrix
    # obs-studio-plugins.wlrobs
    docker
    docker-compose
    lazydocker
    tor-browser
    vlc
    ventoy
    gparted
    # fish
    # koncentro
    # pomotroid
    # pomodoro-gui
    # pomatez
    # pomodorolm
    blueman
    solaar
    logiops
    open-webui
    mongosh
    virt-manager
    dnsmasq
    #luarocks
    yt-dlp
    lynx
    ollama
    lmstudio
    pnpm
    nodejs
    nginx
    gcc
    glibc
    wlroots
    thunar
    thunar-archive-plugin
    gvfs
    cifs-utils
    thunar-volman
    pwvucontrol
    pulseaudio
    pipewire

    rustup
    opencode

    xdg-desktop-portal-wlr
    cloudflared
    rustdesk-flutter
    wget
    wayvnc


    kitty
    foot
    wmenu
    wl-clipboard
    grim
    slurp
    swaybg
    quickshell
    pkgs.noctalia-shell
  ];

  fonts.packages = with pkgs; [
  	nerd-fonts.jetbrains-mono
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 
    80
    1234
  ];

  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
