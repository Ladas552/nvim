local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim" 
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {'catppuccin/nvim',
    lazy = false,
    priority = 1000,
    flavour = "macchiato", -- latte, frappe, macchiato, mocha
    config = function()
      require 'catppuccin' .load()
    end
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {}
  },
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter" },
    dependencies = {
      "hrsh7th/cmp-buffer", -- source for text in buffer
      "hrsh7th/cmp-path", -- source for file system paths
      "L3MON4D3/LuaSnip", -- snippet engine
      "saadparwaiz1/cmp_luasnip", -- for autocompletion
      "rafamadriz/friendly-snippets", -- useful snippets
      "onsails/lspkind.nvim", -- vs-code like pictograms
      "micangl/cmp-vimtex",
    },
    config = function()
      local cmp = require("cmp")

      local luasnip = require("luasnip")

      local lspkind = require("lspkind")

      -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        completion = {
          completeopt = "menu,menuone,preview,noselect",
        },
        snippet = { -- configure how nvim-cmp interacts with snippet engine
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<S-Tab>"] = cmp.mapping.select_prev_item(), -- previous suggestion
          ["<Tab>"] = cmp.mapping.select_next_item(), -- next suggestion
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
          ["<ESC>"] = cmp.mapping.abort(), -- close completion window
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
        }),
        -- sources for autocompletion
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" }, -- snippets
          { name = "buffer" }, -- text within current buffer
          { name = "path" }, -- file system paths
          { name = "neorg" },
          { name = "vimtex" }, 
          { name = "codeium" },
        }),
        -- configure lspkind for vs-code like pictograms in completion menu
        formatting = {
          format = lspkind.cmp_format({
            maxwidth = 50,
            ellipsis_char = "...",
          }),
        },
      })
    end,
  },
  {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        delete_to_trash = true,
        keymaps = {
          ["<BS>"] = "actions.parent",
          ["<C-Return>"] = "actions.open_external",
        },
        view_options = {
          show_hidden = true,
        },
      })
    end,
  },
  {
    'nativerv/cyrillic.nvim',
    event = { 'VeryLazy' },
    config = function()
      require('cyrillic').setup({
        no_cyrillic_abbrev = false, -- default
      })
    end,
  },
  {  "windwp/nvim-autopairs",
    event = { "InsertEnter" },
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    config = function()
      -- import nvim-autopairs
      local autopairs = require("nvim-autopairs")

      -- configure autopairs
      autopairs.setup({
        check_ts = true, -- enable treesitter
        ts_config = {
          lua = { "string" }, -- don't add pairs in lua string treesitter nodes
          javascript = { "template_string" }, -- don't add pairs in javscript template_string treesitter nodes
          java = false, -- don't check treesitter on java
        },
      })

      -- import nvim-autopairs completion functionality
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")

      -- import nvim-cmp plugin (completions plugin)
      local cmp = require("cmp")

      -- make autopairs and completion work together
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
  {
    "chrisgrieser/nvim-scissors",
    dependencies = "nvim-telescope/telescope.nvim", 
    opts = {
      snippetDir = "~/.config/nvim/lua/scissors",
    } 
  },
  --  {
  --    "nvim-neorg/neorg",
  --    build = ":Neorg sync-parsers",
  --    dependencies = { "nvim-lua/plenary.nvim" },
  --    -- event = "VeryLazy",
  --    event = 'VeryLazy',
  --    ft = 'norg',
  --    config = function()
  --      require("neorg").setup {
  --        load = {
  --          ["core.defaults"] = {},
  --          ["core.concealer"] = {
  --            config = {
  --              icon_preset = "diamond",
  --            },
  --          },
  --          ["core.summary"] = {},
  --          ["core.esupports.metagen"] = { config = { timezone = "implicit-local", type = "empty" } },
  --          ["core.completion"] = { config = { engine = "nvim-cmp", name = "[Norg]" } },
  --          ["core.keybinds"] = {
  --            config = {
  --              default_keybinds = true,
  --              neorg_leader = "<Leader><Leader>",
  --            },
  --          },
  --          ["core.journal"] = {
  --            config = {
  --              workspace = "journal",
  --            },
  --          },
  --          ["core.dirman"] = {
  --            config = {
  --              workspaces = {
  --                general = "~/Documents/Norg/",
  --                life = "~/Documents/Norg/Life/",
  --                work = "~/Documents/Norg/Study/",
  --                journal = "~/Documents/Norg/Journal/",
  --              },
  --              default_workspace = "general",
  --            },
  --          },
  --        },
  --      }
  --
  --      vim.wo.foldlevel = 99
  --      vim.wo.conceallevel = 2
  --    end,
  --  },
  {
    "vhyrro/luarocks.nvim",
    branch = "more-fixes",
    config = function()
      require("luarocks").setup({})
    end,
  },
  {
    "nvim-neorg/neorg",
    branch = "luarocks",
    dependencies = { "luarocks.nvim" },
    config = function()
      require("neorg").setup({
        load = {
          ["core.defaults"] = {},
          ["core.concealer"] = {
            config = {
              icon_preset = "diamond",
            },
          },
          ["core.summary"] = {},
          ["core.esupports.metagen"] = { config = { timezone = "implicit-local", type = "empty" } },
          ["core.completion"] = { config = { engine = "nvim-cmp", name = "[Norg]" } },
          ["core.keybinds"] = {
            config = {
              default_keybinds = true,
              neorg_leader = "<Leader><Leader>",
            },
          },
          ["core.journal"] = {
            config = {
              workspace = "journal",
            },
          },
          ["core.dirman"] = {
            config = {
              workspaces = {
                general = "~/Documents/Norg/",
                life = "~/Documents/Norg/Life/",
                work = "~/Documents/Norg/Study/",
                journal = "~/Documents/Norg/Journal/",
              },
              default_workspace = "general",
            },
          },
        },
      })
      vim.wo.foldlevel = 99
      vim.wo.conceallevel = 2
    end
  },
  {
    "kelly-lin/ranger.nvim",
    config = function()
      require("ranger-nvim").setup({ replace_netrw = false })
      vim.api.nvim_set_keymap("n", "<leader>ee", "", {
        noremap = true,
        callback = function()
          require("ranger-nvim").open(true)
        end,
      })
    end,
  },
  {
    "lervag/vimtex",
    ft='tex',
  },
  {
    "okuuva/auto-save.nvim",
    cmd = "ASToggle", -- optional for lazy loading on command
    event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
    opts = {
      -- your config goes here
      -- or just leave it empty :)
    },
  },
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {
      -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
      animation = false,
      auto_hide = true,
      sidebar_filetypes = {
        -- Use the default values: {event = 'BufWinLeave', text = nil}
        NvimTree = true,
      },
    },
    version = '^1.0.0', -- optional: only update when a new 1.x version is released
  },
  {
    "jghauser/mkdir.nvim"
  },
  --{
  --    "axieax/urlview.nvim",
  --  config = function()
  --  local urlview = require("urlview")
  --urlview.setup({
  --default_picker = { "telescope" },
  --     })
  --   end,
  --  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    event = 'VeryLazy',
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          path_display = { "truncate " },
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous, -- move to prev result
              ["<C-j>"] = actions.move_selection_next, -- move to next result
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            },
          },
        },
      })

      telescope.load_extension("fzf")

      -- set keymaps
      local keymap = vim.keymap -- for conciseness

      keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
      keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
      keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
      keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    end,
  },
  {
    "uga-rosa/ccc.nvim",
    event = { "BufReadPre" },
    config = function()
      local ccc = require("ccc")
      ccc.setup {
        highlighter = {
          auto_enable = true,
        },
      }
    end
  },
  --  {
  --    "stevearc/dressing.nvim",
  --    config = function()
  --      require("dressing").setup{
  --
  --      }
  --    end,
  --  },
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup {
        -- config
        theme = 'doom',
        shortcut_type = 'number',
        hide = {
          statusline = true,
        },
        config = {
          header = {
            [[                                                      ]],            
            [[  |                 |               ___|  ___| ___ \  ]],
            [[  |       _` |   _` |   _` |   __|  __ \  __ \    ) | ]],
            [[  |      (   |  (   |  (   | \__ \    ) |   ) |  __/  ]],
            [[ _____| \__,_| \__,_| \__,_| ____/ ____/ ____/ _____| ]],
            [[                                                      ]],
          }, --your header
          center = {
            { action = "Telescope oldfiles",                                       desc = " Recent files",       icon = "󰥔 ",  key = "R" },
            { action = "Telescope find_files",                                     desc = " Find files",         icon = " ",  key = "F" },
            { action = "ene | startinsert",                                        desc = " New file",           icon = " ",  key = "N" },
            { action = "Neorg workspace life",                                     desc = " Neorg Life",         icon = "󰠮 ",  key = "E" },
            { action = "Neorg workspace work",                                     desc = " Neorg Work",         icon = " ",  key = "W" },
            { action = "Neorg journal today",                                      desc = " Neorg Journal",      icon = "󰛓 ",  key = "J" },
            { action = "Lazy",                                                     desc = " Lazy",               icon = "󰒲 ",  key = "L" },
            { action = "qa",                                                       desc = " Quit",               icon = "󰩈 ",  key = "Q" },
          },
          footer = {"Just Do Something Already!"},
        },
      }
    end,
    dependencies = { {'nvim-tree/nvim-web-devicons'}}
  },
  {
    "karb94/neoscroll.nvim",
    event = { "BufReadPre" },
    config = function ()
      require('neoscroll').setup {}
    end
  },
  {
    "Exafunction/codeium.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    ft={
      'python',
      'rust',
      'lua',
    },
    config = function()
      require("codeium").setup({
      })
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
      "windwp/nvim-ts-autotag",
    },
    config = function()
      -- import nvim-treesitter plugin
      local treesitter = require("nvim-treesitter.configs")

      -- configure treesitter
      treesitter.setup({ -- enable syntax highlighting
        highlight = {
          enable = true,
        },
        -- enable indentation
        indent = { enable = true },
        -- enable autotagging (w/ nvim-ts-autotag plugin)
        autotag = {
          enable = true,
        },
        -- ensure these language parsers are installed
        ensure_installed = {
          "html",
          "markdown",
          "markdown_inline",
          "bash",
          "lua",
          "vim",
          "gitignore",
          "make",
          "latex",
          "fish",
          "rust",
          "python",
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
        -- enable nvim-ts-context-commentstring plugin for commenting tsx and jsx
        context_commentstring = {
          enable = true,
          enable_autocmd = false,
        },
      })
    end,
  },
})
