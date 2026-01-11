{ config, pkgs, lib, ... }:

{
  programs.nixvim = {
	enable = true;
    defaultEditor = true;
    colorschemes.base16.autoLoad = true;
    #colorschemes.github-theme.enable = true;
    #colorschemes.google-dark.enable = true;
    colorschemes.darcula.enable = true;
	  #colorschemes.gruvbox.enable = true;
	  #colorschemes.dracula.enable = true;
    colorschemes.tokyonight = {
      enable = true;
      tokyonight-night.enable = true;
    };
    #colorschemes.rose-pine.enable = true;
    #colorschemes.material.enable = true;
    #colorschemes.catppuccin.enable = true;
    #colorschemes.moonfly.enable = true;
    #colorschemes.nightfox.enable = true;
    #colorschemes.carbonfox.enable = true;
    #colorschemes.oxocarbon.enable = true;
    #colorschemes.onedark.enable = true;
    #colorschemes.bluloco.enable = true;


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
      lualine.enable = true;
      telescope.enable = true;
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
      {
        mode = "n";
        key = "<leader>1";
        action = ":colorscheme darkblue<CR>:lua print('ColorScheme: DarkBlue')<CR>";
        options = {
          silent = true;
          remap = false;
        };
      }
      {
        mode = "n";
        key = "<leader>2";
        action = ":colorscheme retrobox<CR>:lua print('ColorScheme: RetroBox')<CR>";
        options = {
          silent = true;
          remap = false;
        };
      }
      {
        mode = "n";
        key = "<leader>3";
        action = ":colorscheme tokyonight-night<CR>:lua print('ColorScheme: TokyoNight-Night')<CR>";
        options = {
          silent = true;
          remap = false;
        };
      }
      {
        mode = "n";
        key = "<leader>4";
        action = ":colorscheme vim<CR>:lua print('ColorScheme: Vim')<CR>";
        options = {
          silent = true;
          remap = false;
        };
      }
    #  {
    #    mode = "n";
    #    key = "<leader>4";
    #    action.__raw = ''
    #    "function() 
    #    vim.cmd('colorscheme tokyonight-storm')
    #    print('ColorScheme: TokyoNight-Storm')
    #    end;
    #    '';
    #    options = {
    #      silent = true;
    #      remap = false;
    #    };
    #  }
    ];
  };
}
