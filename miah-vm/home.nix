{ config, pkgs, inputs, ... }:

{
	home.username = "archgodot";
	home.homeDirectory = "/home/archgodot";
	home.stateVersion = "25.11";
	programs.bash = {
		enable = true;
		shellAliases = {
			btw = "echo I use NixOs btw!";
      nixvim = "nvim";
		};
	};

  home.file.".config/mango".source = ./config/mango;

	programs.alacritty = {
		enable = true;
		settings = {
			window.opacity = 0.8;
			window.padding.x = 5;
			window.padding.y = 5;
			font.size = 12.0;
		};
	};

  programs.rofi.enable = true;
  programs.wofi.enable = true;

  programs.quickshell = {
    enable = true;
    systemd.target = "mango-session.target";
  };

  programs.ghostty = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    };

  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza";
    };
  };

	programs.git = {
		enable = true;
	};

	home.packages = with pkgs; [ 
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    alacritty
    ghostty
    nil
    nodejs
    ripgrep
    pnpm
    hyprland
    niri
    kitty
    scenefx
    waybar
    niriswitcher
    foot
    python3
    zsh
    mongosh
    oh-my-zsh
    # python313Packages.openai
     #python313Packages.pymongo
    # inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.home-manager
	];
}
