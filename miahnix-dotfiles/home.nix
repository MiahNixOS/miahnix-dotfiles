{ config, pkgs, inputs, ... }:

{
	home.username = "archgodot";
	home.homeDirectory = "/home/archgodot";
	home.stateVersion = "25.11";
	programs.bash = {
		enable = true;
		shellAliases = {
			btw = "echo I use NixOs btw!";
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
	programs.git = {
		enable = true;
	};

	#home.file.".config/mango".source = ./config/mango;
	#home.file.".config/nvim".source = ./config/nvim;
  
    home.pointerCursor = {
        gtk.enable = true;
        package = pkgs.vanilla-dmz;
        name = "Vanilla-DMZ";
    };
	
	home.packages = [ 
	inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
	pkgs.alacritty
  # pkgs.neovim
	pkgs.foot
	];
#	programs.zen-browser.enable = true;
}

