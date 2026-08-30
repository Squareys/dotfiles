-- Modern Neovim engine (lazy.nvim + native LSP), bound exactly like the old
-- vimscript config. Options/keymaps/autocmds live in config.vim (sourced at the
-- end) so muscle memory is unchanged. Only coc -> native LSP and CtrlP -> Telescope
-- changed. No node required for C/C++ (clangd is a standalone binary).

-- Leader + plugin globals must be set BEFORE plugins load.
vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.g.vimspector_enable_mappings = "VISUAL_STUDIO"
vim.g.qs_delay = 200

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- ---- Colours + statusline (unchanged look) ----
  { "tomasr/molokai", lazy = false, priority = 1000 },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      local opts = {
        options = {
          theme = "molokai",
          section_separators = { left = "⮀", right = "⮂" },
          component_separators = { left = "⮁", right = "⮃" },
          icons_enabled = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { { "branch", icon = "⭠" }, "diff" },
          lualine_c = { { "filename", symbols = { modified = "", readonly = " ⭤", unnamed = "" } } },
          lualine_x = { "diagnostics", "filetype" },
          lualine_y = { { "location", fmt = function(s) return "⭡ " .. s end } },
          lualine_z = { "progress" },
        },
        inactive_sections = {
          lualine_a = {}, lualine_b = {}, lualine_c = { "filename" },
          lualine_x = { "location" }, lualine_y = {}, lualine_z = {},
        },
      }
      if not pcall(require("lualine").setup, opts) then
        opts.options.theme = "auto"           -- fall back if this lualine build lacks molokai
        require("lualine").setup(opts)
      end
    end,
  },

  -- ---- Editing plugins carried over verbatim ----
  { "ntpeters/vim-better-whitespace", event = "VeryLazy" },   -- <C-S> StripWhitespace+w
  { "tpope/vim-fugitive", cmd = "Git", event = "VeryLazy" },  -- <leader>g*
  { "jeffkreeftmeijer/vim-numbertoggle", event = "VeryLazy" },
  { "scrooloose/nerdtree", cmd = "NERDTree", keys = { { "<S-F8>", ":NERDTree<CR>" } } },
  { "tommcdo/vim-exchange", event = "VeryLazy" },             -- cx
  { "tpope/vim-surround", event = "VeryLazy" },               -- ys/cs/ds
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "zef/vim-cycle", event = "VeryLazy" },                    -- <C-A>
  { "unblevable/quick-scope", event = "BufReadPost" },
  { "bkad/CamelCaseMotion", lazy = false },                   -- <leader>w/b/e (config.vim calls its setup at source time)
  { "vim-scripts/a.vim", ft = { "c", "cpp" } },               -- :A header<->source
  { "puremourning/vimspector", ft = { "c", "cpp", "python" } },

  -- ---- Fuzzy finder (replaces ctrlp; Ctrl+P kept) ----
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<C-p>",      function() require("telescope.builtin").find_files({ hidden = true }) end, desc = "Find files (incl. dotfiles)" },
      { "<leader>ff", function() require("telescope.builtin").find_files({ hidden = true }) end, desc = "Find files (incl. dotfiles)" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end,  desc = "Live grep" },
      { "<leader>fc", function() require("telescope.builtin").find_files({ cwd = vim.fn.expand("~/.config"), hidden = true }) end, desc = "Find files in ~/.config" },
    },
    opts = { defaults = { file_ignore_patterns = { "node_modules", "%.git/", "build/", "dist/" } } },
  },

  -- ---- Syntax (replaces polyglot/cpp-highlight) ----
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",   -- classic API (require('nvim-treesitter.configs').setup); main branch dropped it
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = { "c", "cpp", "lua", "python", "javascript", "typescript",
                           "json", "css", "html", "glsl", "bash", "vim", "markdown" },
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end,
  },

  -- ---- LSP (replaces coc; clangd needs no node) ----
  { "williamboman/mason.nvim", cmd = "Mason", opts = {} },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim", "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- clangd + lua_ls are node-free; the web servers only install if you add node.
      require("mason-lspconfig").setup({ ensure_installed = { "clangd", "lua_ls" } })
      local caps = require("cmp_nvim_lsp").default_capabilities()
      local servers = { "clangd", "lua_ls", "ts_ls", "cssls", "jsonls", "eslint" }
      for _, s in ipairs(servers) do
        pcall(function() vim.lsp.config(s, { capabilities = caps }) end)
        pcall(vim.lsp.enable, s)
      end
    end,
  },

  -- ---- Completion + snippets (replaces coc completion, same keys) ----
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path",
      { "L3MON4D3/LuaSnip", dependencies = { "rafamadriz/friendly-snippets" },
        config = function() require("luasnip.loaders.from_vscode").lazy_load() end },
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp, luasnip = require("cmp"), require("luasnip")
      local function has_words_before()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
      cmp.setup({
        snippet = { expand = function(a) luasnip.lsp_expand(a.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),                       -- your <c-space>
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),       -- your <cr> select-first
          ["<Tab>"] = cmp.mapping(function(fallback)                    -- your <Tab> behaviour
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            elseif has_words_before() then cmp.complete()
            else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { "i", "s" }),
          ["<C-l>"] = cmp.mapping(function() if luasnip.jumpable(1) then luasnip.jump(1) end end, { "i", "s" }),
          ["<C-h>"] = cmp.mapping(function() if luasnip.jumpable(-1) then luasnip.jump(-1) end end, { "i", "s" }),
        }),
        sources = { { name = "nvim_lsp" }, { name = "luasnip" }, { name = "buffer" }, { name = "path" } },
      })
    end,
  },

  -- ---- Formatting (replaces coc-prettier / vim-clang-format) ----
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = {
      formatters_by_ft = {
        c = { "clang_format" }, cpp = { "clang_format" },
        javascript = { "prettier" }, typescript = { "prettier" },
        css = { "prettier" }, html = { "prettier" }, json = { "prettier" },
      },
    },
  },
}, {
  ui = { border = "rounded" },
  performance = { rtp = { disabled_plugins = { "netrw", "netrwPlugin", "tarPlugin",
    "zipPlugin", "gzip", "tohtml", "tutor" } } },
})

-- ---- LSP keymaps (identical to the old coc bindings) ----
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local b = { buffer = ev.buf, silent = true }
    local map = vim.keymap.set
    map("n", "gd", vim.lsp.buf.definition, b)
    map("n", "gy", vim.lsp.buf.type_definition, b)
    map("n", "gi", vim.lsp.buf.implementation, b)
    map("n", "gr", vim.lsp.buf.references, b)
    map("n", "K",  vim.lsp.buf.hover, b)
    map("n", "[g", function() vim.diagnostic.jump({ count = -1 }) end, b)
    map("n", "]g", function() vim.diagnostic.jump({ count = 1 }) end, b)
    map("n", "<leader>rn", vim.lsp.buf.rename, b)
    map("n", "<F2>",       vim.lsp.buf.rename, b)
    map("n", "<C-,>", function() require("telescope.builtin").lsp_document_symbols() end, b)
    map("n", "<C-i>", function()                                  -- organize imports (was :OR)
      vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
    end, b)
  end,
})

-- Format on <C-f> (buffer) and <leader>f (buffer/selection) + :Format — was coc.
local function fmt() require("conform").format({ async = true, lsp_format = "fallback" }) end
vim.keymap.set({ "n", "x" }, "<leader>f", fmt, { silent = true })
vim.keymap.set("n", "<C-f>", fmt, { silent = true })
vim.api.nvim_create_user_command("Format", fmt, {})

-- Colours (truecolor molokai)
vim.o.termguicolors = true
pcall(vim.cmd, "silent! colorscheme molokai")

-- Finally, load the ported options/keymaps/autocmds.
vim.cmd("source " .. vim.fn.stdpath("config") .. "/config.vim")

-- To instead follow the noctalia (kitty) palette rather than molokai:
--   set vim.o.termguicolors=false and delete the two molokai lines above.
