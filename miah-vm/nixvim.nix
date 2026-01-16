{ config, pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    colorschemes.gruvbox.enable = true;
    #colorschemes.dracula.enable = true;
    #colorschemes.tokyonight.enable = true;
    termguicolors = true;
    colorschemes.base16 = {
      enable = true;
      autoload = true;
      setUpBar = true;
    };

    colorscheme = "vim";

    globals.mapleader = " ";

    opts = {
      number = true;
      # relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      softtabstop = 2;
      expandtab = true;
      shiftround = true;
      splitbelow = true;
      linebreak = true;
      wrap = true;
      textwidth=40;
      # smartindent = true;

      clipboard = "unnamedplus";
    };

    plugins = {
      #treesitter.enable = true;
      #lazy.enable = true;
      autoclose.enable = true;
      dashboard.enable = true;
      web-devicons.enable = true;
      snacks.nvim.enable = true;
      snacks.rename.enable = true;
      image.nvim.enable = true;
      nvim-tree.enable = true;
      lualine.enable = true;

      bufferline = {
        enable = true;
        auto_hide = true;
        options = {
          mode = "tabs";
          auto_hide = true;
        };
      };

      toggleterm = {
        enable = true;
        height = 15;
        insert_mappings = false;
        terminal_mappings = true;
        direction = "horizontal";
      };

      #obsidian.enable = true;
      telescope = {
        enable = true;
        extensions = {
          fzf-native.enable = true;
        };
        settings = {
          defaults = {
            layout_config = { 
              prompt_position = "top";
              height = 5;
            };
            sorting_strategy = "ascending";
          };
        };
      };
      
      which-key.enable = true;
      nvim-lspconfig.enable = true;
      nvim-cmp.enable = true;
      copilot.enable = true;
      mason.enable = true;
      lazygit.enable = true;
      colorscheme = {
        enable = true;
        vim.enable = true;
      };
      marks.enable = true;
      nix.enable = true;
    };

    extraPackages = with pkgs; [
      ripgrep
      git
    ];

    keymaps = [
      {
        mode = [ "n" "t" ];
        key = "<C-t>";
        action = "<cmd>ToggleTerm<CR>";
        options = {
          silent = true;
          remap = false;
        };
      }
      {
        mode = [ "n" "t" ];
        key = "<C-h>";
        action = "<C-w>h";
        options = {
          silent = true;
          remap = false;
        };
      }
      {
        mode = [ "n" "t" ];
        key = "<C-l>";
        action = "<C-w>l";
        options = {
          silent = true;
          remap = false;
        };
      }
      {
        mode = [ "n" "t" ];
        key = "<C-j>";
        action = "<cmd>wincmd j<CR>";
        options = {
          silent = true;
          remap = false;
        };
      }
      {
        mode = [ "n" "t" ];
        key = "<C-k>";
        action = "<cmd>wincmd k<CR>";
        options = {
          silent = true;
          remap = false;
        };
      }
      {
        mode = [ "n" "t" ];
        key = "<C-n>";
        action = "<cmd>bn<CR>";
        options = {
          silent = true;
          remap = false;
        };
      }
      {
        mode = [ "n" "t" ];
        key = "<C-p>";
        action = "<cmd>bp<CR>";
        options = {
          silent = true;
          remap = false;
        };
      }
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>NvimTreeToggle<CR>";
        options = {
          silent = true;
          remap = true;
        };
      }
      {
        mode = "n";
        key = "<leader>q";
        action = "<cmd>bdelete<CR>";
        options = {
          silent = true;
          remap = false;
        };
      }
      {
        mode = "n";
        key = "<C-q>";
        action = "<cmd>bdelete<CR>";
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
        action = ":colorscheme elflord<CR>:lua print('The Great Elf Lord Has Returned!')<CR>";
        options = {
          silent = true;
          remap = false;
        };
      }
      {
        mode = "n";
        key = "<leader>3";
        action = ":colorscheme vim<CR>:lua print('ColorScheme: Vim')<CR>";
        options = {
          silent = true;
          remap = false;
        };
      }
      {
        mode = "n";
        key = "<leader>4";
        action = ":colorscheme base16-ayu-dark<CR>:lua print('ColorScheme: (B16) Ayu-Dark')<CR>";
        options = {
          silent = true;
          remap = false;
        };
      }
      {
        mode = "n";
        key = "<leader>5";
        action = ":colorscheme pablo<CR>:lua print('ColorScheme: Pablo')<CR>";
        options = {
          silent = true;
          remap = false;
        };
      }
      {
        mode = "n";
        key = "<leader>6";
        action = ":colorscheme base16-blueforest<CR>:lua print('ColorScheme: (B16) BlueForest')<CR>";
        options = {
          silent = true;
          remap = false;
        };
      }
      {
        mode = "n";
        key = "<leader>7";
        action = ":colorscheme base16-colors<CR>:lua print('ColorScheme: (B16) Colors')<CR>";
        options = {
          silent = true;
          remap = false;
        };
      }
      {
        mode = "n";
        key = "<leader>8";
        action = ":colorscheme base16-da-one-black<CR>:lua print('ColorScheme: (B16) da-one-black')<CR>";
        options = {
          silent = true;
          remap = false;
        };
      }
      {
        mode = "n";
        key = "<leader>9";
        action = ":colorscheme base16-framer<CR>:lua print('ColorScheme: (B16) Framer')<CR>";
        options = {
          silent = true;
          remap = false;
        };
      }
      {
        mode = "n";
        key = "<leader>0";
        action = ":colorscheme base16-atelier-seaside<CR>:lua print('ColorScheme: (B16) AteLier-SeaSide')<CR>";
        options = {
          silent = true;
          remap = false;
        };
      }
      {
        mode = "n";
        key = "<leader>C";
        action = ":Telescope colorscheme enable_preview=true<CR>";
        options = {
          silent = true;
          remap = false;
        };
      }
    ];
  };
}
