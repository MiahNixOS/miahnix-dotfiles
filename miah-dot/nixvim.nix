{ config, pkgs, ... }:

{
  programs.nixvim = {
	enable = true;
    defaultEditor = true;
	colorschemes.gruvbox.enable = true;
	#colorschemes.dracula.enable = true;
    #colorschemes.tokyonight.enable = true;

	globals.mapleader = " ";

    opts = {
      number = true;
      # relativenumber = true;
      shiftwidth = 4;
      tabstop = 4;
      expandtab = true;
    };

    plugins = {
      treesitter.enable = true;
      lazy.enable = true;
    };

    extraPackages = with pkgs; [
      ripgrep
      git
    ];
  };
}
