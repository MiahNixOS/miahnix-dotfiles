        programs.neovim = {
          enable = true;
          defaultEditor = true; # (optional) makes nvim the default system editor
          viAlias = true; # (optional)
          vimAlias = true; # (optional)
          # Add necessary system packages like ripgrep, language servers, etc.
          plugins = with pkgs.vimPlugins; [
            nvim-treesitter
            nvim-lspconfig
          ];
          extraPackages = with pkgs; [
            # example LSPs and tools
            tree-sitter
            lua-language-server
            pyright 
            stylua
            gcc
            ripgrep
            git
          ];
        };

