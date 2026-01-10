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
      shiftwidth = 2;
      tabstop = 2;
      softtabstop = 2;
      expandtab = true;
      shiftround = true;
      # smartindent = true;

      clipboard = "unnamedplus";

    };

    plugins = {
      #treesitter.enable = true;
      #lazy.enable = true;
      autoclose.enable = true;
      #dashboard.enable = true;
      web-devicons.enable = true;
      snacks.nvim.enable = true;
      snacks.rename.enable = true;
      image.nvim.enable = true;
      nvim-tree.enable = true;
    };

    extraPackages = with pkgs; [
      ripgrep
      git
    ];

    keymaps = [
      {
        mode = "n";
        key = "<leader>e";
        #action = ":NvimTreeToggle<CR>";
        action = "<cmd>NvimTreeToggle<CR>";
        options = {
          silent = true;
          remap = true;
        };
      }

      {
        mode = "n";
        key = "<leader>q";
        action = ":q<CR>";
        options = {
          silent = true;
          remap = false;
        };
      }
    ];
  };
}
