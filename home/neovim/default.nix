{ config, pkgs, lib, ... }:
let
  # fromGithub can download a neovim plugin from Github.
  # For example: (fromGitHub "6422c3a651c3788881d01556cb2a90bdff7bf002" "master" "Shopify/shadowenv.vim")
  fromGitHub = rev: ref: repo: pkgs.vimUtils.buildVimPlugin {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = ref;
      rev = rev;
    };
  };

  nvim-treesitter-with-plugins = pkgs.vimPlugins.nvim-treesitter.withPlugins (treesitter-plugins:
    with treesitter-plugins; [
      lua
      c
      vimdoc

      bash
      nix
      make
      markdown
      sql
      ssh_config

      python

      go
      gomod
      gosum
      gowork

      tsx
      typescript
      javascript
      vue

      yaml
      json
      terraform
    ]
  );
in
{
  programs.neovim = {
    enable = true;

    # Set as default editor, including aliases.
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      # This fixes a bug where config did not get put on top of the init.vim file.
      {
        plugin = pkgs.emptyDirectory;
        config = builtins.readFile ./config.vim;
      }

      {
        plugin = pkgs.emptyDirectory;
        config = builtins.readFile ./config.lua;
        type = "lua";
      }

      {
        plugin = pkgs.emptyDirectory;
        config = builtins.readFile ./mappings.lua;
        type = "lua";
      }


      { # https://github.com/catppuccin/nvim
        plugin = catppuccin-nvim;
        type = "lua";
        config = builtins.readFile ./plugins/catpuccin.lua;
      }

      { # highly extendable fuzzy finder over lists. https://github.com/nvim-telescope/telescope.nvim
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          local telescope_builtin = require('telescope.builtin')
          vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, { desc = "Telescope - Find files" })
          vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, { desc = "Telescope - Live grep" })
          vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, { desc = "Telescope - Show buffers" })
          vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, { desc = "Telescope - Help tags" })
        '';
      }

      # Parsing system for languages, better highlighting
      nvim-treesitter-with-plugins

      # Add file explorer
      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = ''
          vim.keymap.set("n", "<Leader>v", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file browser" })
          vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "Focus file browser" })

          require("nvim-tree").setup({
            disable_netrw = true,
            view = {
              adaptive_size = false,
              side = "left",
              width = 30,
              preserve_window_proportions = true,
            },
            git = {
              enable = true,
              ignore = true,
            },
            filesystem_watchers = {
              enable = true,
            },
          })
        '';
      }
      # Include dev-icons https://github.com/nvim-tree/nvim-web-devicons
      {
        plugin = nvim-web-devicons;
        type = "lua";
        config = ''
          require("nvim-web-devicons").setup({})
        '';
      }

      {
        plugin = indent-blankline-nvim;
        type = "lua";
        config = ''
          require("ibl").setup({
            scope = {
              enabled = false,
            },
            indent = {
              char = "│",
            },
          })
        '';
      }
#
#      # It's important that you set up the plugins in the following order:
#      #
#      #    mason.nvim
#      #    mason-lspconfig.nvim
#      #    Setup servers via lspconfig
#      #
#      #Pay extra attention to this if you lazy-load plugins, or somehow "chain" the loading of plugins via your plugin manager.
#
#      {
#        plugin = mason-nvim;
#        type = "lua";
#        config = ''
#          require("mason").setup({})
#        '';
#      }
#
#      {
#        plugin = mason-lspconfig-nvim;
#        type = "lua";
#        config = ''
#          require("mason-lspconfig").setup({})
#        '';
#      }
#
#      nvim-lspconfig
#
#
#
#      {
#        plugin = lsp-zero-nvim;
#        type = "lua";
#        config = ''
#          require('lsp-zero')
#        '';
#      }
#
#      {
#        plugin = nvim-cmp;
#        type = "lua";
#        config = ''
#          local cmp = require('cmp')
#
#          vim.keymap.set("n", "C-<space>", cmp.mapping.complete())
#
#          cmp.setup({})
#        '';
#      }

      # Add whichkey support
      {
        plugin = (fromGitHub "4433e5ec9a507e5097571ed55c02ea9658fb268a" "main" "folke/which-key.nvim");
        type = "lua";
        config = ''
          -- Show all keymaps
          vim.keymap.set("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "Whichkey all keymaps" })

          -- Allow for sarching keymaps
          vim.keymap.set("n", "<leader>wk", function()
            vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
          end, { desc = "Whichkey query lookup" })

          require("which-key").register(mappings, opts)
        '';
      }
    ];
  };
}
