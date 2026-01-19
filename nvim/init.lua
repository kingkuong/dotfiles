-- ----------------------------------------------------------------- --
-- Neovim config (Lua)                                               --
-- ----------------------------------------------------------------- --

-- Enable true colors for better syntax highlighting
vim.opt.termguicolors = true

-- Basic settings
vim.cmd("syntax on")
vim.cmd("filetype on")

vim.opt.title = true
vim.opt.encoding = "utf-8"
vim.opt.showcmd = false
vim.opt.scrolljump = 5
vim.opt.number = true
vim.opt.showmode = true
vim.opt.mouse = "a"
vim.opt.conceallevel = 0

-- Cursor and rendering
vim.opt.cursorline = true
vim.opt.lazyredraw = true
vim.opt.mousehide = true
vim.opt.backspace = "indent,eol,start"

-- Search settings
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.wrapscan = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Tab/indent settings
vim.opt.tabstop = 4
vim.opt.softtabstop = 0
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.smarttab = true

-- Path for file searching
vim.opt.path = vim.fn.getcwd() .. "/**"

-- Security settings for directory-level config
vim.opt.exrc = true
vim.opt.secure = true

-- ----------------------------------------------------------------- --
-- Autocommands                                                      --
-- ----------------------------------------------------------------- --

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Trim whitespace on save
autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})

-- Restore cursor position
augroup("resCur", { clear = true })
autocmd("BufReadPost", {
  group = "resCur",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Python settings
autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- Markdown spell check
autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.spell = true
  end,
})

-- ----------------------------------------------------------------- --
-- Keymaps                                                           --
-- ----------------------------------------------------------------- --

local keymap = vim.keymap.set

-- Set localleader
vim.g.maplocalleader = "-"

-- Use %% to get current directory in command mode
vim.cmd([[cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%']])

-- Function keys
keymap("n", "<F2>", "<cmd>noh<CR>", { desc = "Clear search highlight" })
keymap("n", "<F3>", "<cmd>set spell<CR>", { desc = "Enable spell check" })
keymap("n", "<F4>", "<cmd>set nospell<CR>", { desc = "Disable spell check" })
keymap("n", "<F7>", "<cmd>set invnumber<CR>", { desc = "Toggle line numbers" })

-- Escape with jk
keymap("i", "jk", "<ESC>")

-- Repeat in visual mode
keymap("v", ".", ":norm.<CR>")

-- Search and replace word under cursor
keymap("n", "<Leader>s", [[:%s/\<<C-r><C-w>\>//g<Left><Left>]], { desc = "Replace word under cursor" })

-- Split into multiple lines based on pattern
keymap("v", "SS", [[:%s//&\r/g<CR>]])

-- Tag navigation
keymap("n", "<C-\\>", '<cmd>tab split<CR><cmd>exec("tag ".expand("<cword>"))<CR>')
keymap("n", "<A-]>", '<cmd>vsp<CR><cmd>exec("tag ".expand("<cword>"))<CR>')

-- ----------------------------------------------------------------- --
-- Command aliases                                                   --
-- ----------------------------------------------------------------- --

vim.cmd([[
  ca F find
  ca FS Files
  ca H help
  ca WQ wq
  ca Wq wq
  ca W w
  ca Q q
  ca Qa qa
  ca QA qa
  cmap w!! w !sudo tee % > /dev/null %
  cmap aa! argadd%
  cmap ad! argdelete%
]])

-- Rpdf command to read PDF inside vim
vim.api.nvim_create_user_command("Rpdf", function(opts)
  vim.cmd("r !pdftotext -nopgbrk " .. vim.fn.shellescape(opts.args) .. " - | fmt -csw78")
end, { nargs = 1, complete = "file" })

-- ----------------------------------------------------------------- --
-- Abbreviations (Python)                                            --
-- ----------------------------------------------------------------- --

autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.cmd([[
      iabbrev <buffer> pdb import pdb; pdb.set_trace()
      iabbrev <buffer> ipdb import ipdb; ipdb.set_trace()
      iabbrev <buffer> pprint from pprint import pprint as pp
      iabbrev <buffer> _main if __name__ == '__main__':
    ]])
  end,
})

-- ----------------------------------------------------------------- --
-- Plugins (lazy.nvim)                                               --
-- ----------------------------------------------------------------- --

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin setup
require("lazy").setup({
  -- Colorscheme (for better syntax colors)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        integrations = {
          treesitter = true,
          telescope = true,
          mason = true,
          cmp = true,
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Icons for file types
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({
        default = true,
        strict = true,
      })
    end,
  },

  -- Mason: LSP server manager
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "ts_ls",
          "pyright",
          "gopls",
          "html",
          "cssls",
          "eslint",
          "tailwindcss",
          "marksman",
        },
      })
    end,
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      vim.lsp.config("pyright", {
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      vim.lsp.enable("ts_ls")
      vim.lsp.enable("pyright")
      vim.lsp.enable("gopls")
      vim.lsp.enable("html")
      vim.lsp.enable("cssls")
      vim.lsp.enable("tailwindcss")
      vim.lsp.enable("eslint")
      vim.lsp.enable("marksman")

      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
          },
        },
        virtual_text = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          keymap("n", "gd", vim.lsp.buf.definition, opts)
          keymap("n", "K", vim.lsp.buf.hover, opts)
          keymap("n", "gt", vim.lsp.buf.implementation, opts)
          keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
          keymap("n", "<leader>fr", vim.lsp.buf.references, opts)
          keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          keymap("n", "[d", vim.diagnostic.goto_prev, opts)
          keymap("n", "]d", vim.diagnostic.goto_next, opts)
        end,
      })
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- Treesitter: Better syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- Install parsers
      local parsers = {
        "lua", "vim", "vimdoc", "python", "javascript", "typescript",
        "tsx", "go", "html", "css", "json", "yaml", "markdown",
        "markdown_inline", "bash",
      }
      for _, parser in ipairs(parsers) do
        pcall(function()
          vim.treesitter.language.add(parser)
        end)
      end

      -- Enable treesitter highlighting
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },

  -- oil.nvim: Edit filesystem like a buffer
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        columns = { "icon" },
        buf_options = { buflisted = false, bufhidden = "hide" },
        win_options = { wrap = false, signcolumn = "no", cursorcolumn = false },
        delete_to_trash = false,
        skip_confirm_for_simple_edits = false,
        prompt_save_on_select_new_entry = true,
        cleanup_delay_ms = 2000,
        git = {
          add = function(path)
            return false
          end,
        },
        view_options = {
          show_hidden = false,
          is_always_hidden = function(name, _)
            return vim.tbl_contains({ ".git", "node_modules", ".cache", "__pycache__" }, name)
          end,
        },
      })
      keymap("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })
      keymap("n", "<leader>-", function()
        require("oil").toggle_float()
      end, { desc = "Open oil (float)" })
    end,
  },

  -- Telescope fuzzy search
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")

      -- Enable fzf-native for better fuzzy matching
      telescope.load_extension("fzf")
      telescope.setup({
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })

      keymap("n", "<leader>ff", builtin.find_files, { desc = "Fuzzy find files" })
      keymap("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
      keymap("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
      vim.api.nvim_create_user_command("GF", builtin.find_files, {})
    end,
  },

  -- conform.nvim: Formatting
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          go = { "goimports" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          json = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
        },
      })
      autocmd("BufWritePre", {
        pattern = { "*.go", "*.js", "*.ts", "*.jsx", "*.tsx", "*.json", "*.html", "*.css", "*.lua" },
        callback = function()
          require("conform").format({ async = false, lsp_fallback = true })
        end,
      })
      keymap("n", "<leader>fm", function()
        require("conform").format({ async = false, lsp_fallback = true })
      end, { desc = "Format buffer" })
    end,
  },

  -- trouble.nvim: Pretty diagnostics list
  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup()
      keymap("n", "<leader>xx", function()
        require("trouble").toggle()
      end, { desc = "Toggle trouble" })
      keymap("n", "<leader>xw", function()
        require("trouble").toggle("workspace_diagnostics")
      end, { desc = "Workspace diagnostics" })
      keymap("n", "<leader>xd", function()
        require("trouble").toggle("document_diagnostics")
      end, { desc = "Document diagnostics" })
    end,
  },
})
