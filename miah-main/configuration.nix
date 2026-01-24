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
    # hardware.decklink.enable = true;
    boot.kernelModules = [ "kvm-amd" ];
    programs.xwayland.enable = true;
    programs.virt-manager = {
      enable = true;
    };

    systemd.services.libvirtd.unitConfig.RequiresMountsFor = [ "/mnt/MacStore" ];
    virtualisation.spiceUSBRedirection.enable = true;
    users.groups.libvirtd.members = ["archgodot"];
    nix.settings.download-buffer-size = 52488000;

    virtualisation.libvirtd = {
        enable = true;
        onBoot = "start";
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
 
  xdg.portal = {
  	enable = true;
	wlr.enable = true;
  };

  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  services.gvfs.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONEWL=1;
  };

  services.samba.enable = true;
  services.avahi.enable = true;
  services.tumbler.enable = true;

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_18; # Use this line
  };

  networking.hostName = "miahnix"; # Define your hostname.
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

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

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  programs.hyprland = {
    enable = true;
	  xwayland.enable = true;
  };

  programs.mango = {
  	enable = true;
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

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
  };

  programs.fish.enable = true;
  programs.starship.enable = true;
  environment.shells = with pkgs; [ fish ];

  users.users.archgodot = {
    isNormalUser = true;
    description = "ArchGodot";
    extraGroups = [ "docker" "networkmanager" "wheel" "libvirtd" "virsh" ];

    shell = pkgs.fish;

    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  services.open-webui.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.firefox.enable = true;

  nixpkgs.config = {
    cudaSupport = true;
    allowUnfree = true;
  };

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
    bat
    btop
    neofetch
    cmatrix
    docker
    docker-compose
    lazydocker
    tor-browser
    vlc
    ffmpeg
    killall
    starship
    emacs
    ripgrep
    fd
    libvterm
    audacity
    hyprshot
    qt6.qtwayland
    qt5.qtwayland
    nix-ld
    xwayland-satellite
    libappindicator
    blender
    godot
    davinci-resolve-studio
    gparted
    systrayhelper
    blueman
    solaar
    logiops
    open-webui
    mongosh
    virt-manager
    dnsmasq
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
  ];

  fonts.packages = with pkgs; [
  	nerd-fonts.jetbrains-mono
    jetbrains-mono
    # fonts.jetbrains.mono
  ];

  programs.nix-ld.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  networking.firewall.enable = true;
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 
    80
    1234
  ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "25.11"; # Did you read the comment?

}
