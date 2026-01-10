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


    plugins.neo-tree.enable = true;
    plugins.neo-tree.settings = {
      close_if_last_window = true;
      filesystem = {
        filtered_items = {
          hide_dotfiles = false;
        };
      };
    };

    plugins = {
      treesitter.enable = true;
      lazy.enable = true;
      autoclose.enable = true;
      dashboard.enable = true;
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
        action = ":Neotree filesystem reveal left<CR>";
        options = {
          desc = "Toggle Neo-Tree";
        };
      }
      {
        mode = "n";
        key = "<leader>E";
        action = ":NvimTreeToggle<CR>";
        options = {
          silent = true;
          remap = false;
        };
      }
    ];

  };
}
