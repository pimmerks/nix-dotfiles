{ config, pkgs, lib, ... }:
let
  # fromGithub can download a neovim plugin from Github.
  # For example: (fromGitHub "6422c3a651c3788881d01556cb2a90bdff7bf002" "master" "Shopify/shadowenv.vim")
  fromGitHub = rev: ref: repo: pkgs.vimUtils.buildVimPlugin {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      inherit ref;
      inherit rev;
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

      # Use for some ui components
      # nvchad-ui

      # Add file explorer
      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = ''
          vim.keymap.set("n", "<Leader>v", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file browser" })
          vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "Focus file browser" })
          vim.keymap.set("n", "<leader>E", "<cmd>NvimTreeClose<CR>", { desc = "Close file browser" })

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

          -- From: https://github.com/nvim-tree/nvim-tree.lua/issues/1368#issuecomment-1512248492
          vim.api.nvim_create_autocmd("QuitPre", {
            callback = function()
              local invalid_win = {}
              local wins = vim.api.nvim_list_wins()
              for _, w in ipairs(wins) do
                local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
                if bufname:match("NvimTree_") ~= nil then
                  table.insert(invalid_win, w)
                end
              end
              if #invalid_win == #wins - 1 then
                -- Should quit, so we close all invalid windows.
                for _, w in ipairs(invalid_win) do vim.api.nvim_win_close(w, true) end
              end
            end
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
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = ''
          require('gitsigns').setup()
        '';
      }

      # It's important that you set up the plugins in the following order:
      #
      #    mason.nvim
      #    mason-lspconfig.nvim
      #    Setup servers via lspconfig
      #
      # Pay extra attention to this if you lazy-load plugins, or somehow "chain" the loading of plugins via your plugin manager.
      {
        plugin = mason-nvim;
        type = "lua";
        config = ''
          require("mason").setup()
        '';
      }
      {
        plugin = cmp-nvim-lsp;
        type = "lua";
        config = ''
          local capabilities = require('cmp_nvim_lsp').default_capabilities()
        '';
      }

      {
        plugin = mason-lspconfig-nvim;
        type = "lua";
        config = ''
          local mason_lspconfig = require("mason-lspconfig")
          mason_lspconfig.setup()

          mason_lspconfig.setup_handlers {
            function (server_name) -- default handler (optional)
              require("lspconfig")[server_name].setup {
                capabilities = capabilities,
              }
            end,
          }
        '';
      }

      {
        plugin = pkgs.emptyDirectory;
        type = "lua";
        config = ''
        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(args)
            local bufnr = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)

            local function opts(desc)
              return { buffer = bufnr, desc = "LSP " .. desc .. "(" .. client.name .. ")" }
            end
            local map = vim.keymap.set

            map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
            map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
            map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
            map("n", "<leader>sh", vim.lsp.buf.signature_help, opts "Show signature help")
            map("n", "<leader>h", vim.lsp.buf.hover, opts "Show hover text")
            map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")

            map("n", "<leader>fm", vim.lsp.buf.format, opts "Format buffer")
            map("n", "<leader>ar", vim.lsp.buf.rename, opts "Rename symbol")

            map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
            map("n", "gr", vim.lsp.buf.references, opts "Show references")

            if client.name == "clangd" then
              vim.keymap.set('n', 'gI', "<Cmd>ClangdSwitchSourceHeader<CR>", opts "Switch to Header file (clangd)")
            end


            -- Enable inlay hints if they are supported
            local toggle_inlay_hints = function ()
              local inlay_hint = vim.lsp.inlay_hint
              if inlay_hint.is_enabled() then
                inlay_hint.enable(false, nil)
              else
                inlay_hint.enable(true, nil)
              end
            end

            if client.supports_method("textDocument/inlayHint") or client.server_capabilities.inlayHintProvider then
              vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
              map("n", "<leader>ti", toggle_inlay_hints, opts "Toggle inlay hints")
            end

            -- Some other stuff that was in examples ?
            if client.server_capabilities.completionProvider then
              vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
            end

            if client.server_capabilities.definitionProvider then
              vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
            end


            -- Attach CursorHold mode
            -- vim.api.nvim_create_autocmd("CursorHold", {
            --   callback = function(args)
            --     if not require("cmp").visible() then
            --       vim.lsp.buf.hover({focusable = false})
            --     end
            --   end
            -- })

          end,
        })

        '';
      }

      cmp-path
      cmp-buffer

      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          local lspconfig = require("lspconfig")

          lspconfig.nil_ls.setup {
            capabilities = capabilities,
            cmd = {"${pkgs.nil}/bin/nil"},
            -- on_attach = custom_on_attach,
          }

          lspconfig.clangd.setup {
            capabilities = capabilities,
            -- cmd = {"${pkgs.clang-tools}/bin/clangd", "--clang-tidy"},
            cmd = {"/nix/store/gsyj23nm76scqjd4jgwq74v03m02k3rj-esp-clang-esp-idf-v5.1.3/bin/clangd", "--clang-tidy"},
            -- on_attach = custom_on_attach,
          }

          lspconfig.lua_ls.setup {
            capabilities = capabilities,
            settings = {
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                library = {
                  vim.fn.expand "$VIMRUNTIME/lua",
                  vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
                },
                maxPreload = 100000,
                preloadFileSize = 10000,
              },
            },
          }
        '';
      }

      {
        plugin = nvim-cmp;
        type = "lua";
        config = ''
          local cmp = require('cmp')

          cmp.setup({
            window = {
              completion = cmp.config.window.bordered(),
              documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.abort(),
              ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            }),
            formatting = {
              expandable_indicator = true,
              fields = {'menu', 'abbr', 'kind'},
              format = function(entry, item)
                local menu_icon = {
                  nvim_lsp = 'λ',
                  vsnip = '⋗',
                  buffer = 'Ω',
                  path = '🖫',
                }

                item.menu = menu_icon[entry.source.name]
                return item
              end,
            },
            sources = cmp.config.sources({
              { name = 'nvim_lsp' },
              -- { name = 'vsnip' },
              { name = 'path' },
            }, {
              { name = 'buffer' },
            })
          })
        '';
      }

      # Add whichkey support
      {
        plugin = fromGitHub "4433e5ec9a507e5097571ed55c02ea9658fb268a" "main" "folke/which-key.nvim";
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
