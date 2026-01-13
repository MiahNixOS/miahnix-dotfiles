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

	programs.alacritty = {
		enable = true;
		settings = {
			window.opacity = 0.8;
			window.padding.x = 5;
			window.padding.y = 5;
			font.size = 12.0;
		};
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

	home.packages = [ 
	inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
	pkgs.alacritty
  pkgs.ghostty
	pkgs.foot
  pkgs.python3
  pkgs.zsh
  pkgs.mongosh
  pkgs.oh-my-zsh
  pkgs.python313Packages.openai
  pkgs.python313Packages.pymongo
  inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.home-manager
	];
}
