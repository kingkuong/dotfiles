" ----------------------------------------------------------------- "
" Vim config                                                        "
" ----------------------------------------------------------------- "
syntax on
filetype on

set title               " change the terminal title
set encoding=utf-8      " show utf8-chars
set noshowcmd           " not count highlighted
set scrolljump=5        " when fast scrolling, do 5 lines instead of 1
set number              " display number line
set showmode            " -- INSERT (appreciation)-- :)
set mouse=a             " use the mouse
set conceallevel=0      " no concealing

"set directory=.        " changed directory for swap files

" Enable if have terminal with fast drawing
"set cursorcolumn        " vertical highlight
set cursorline          " horizontal highlight
set lazyredraw

set mousehide           " hide the mouse when typing
set backspace=2         " backspace over indent, eol, and insert

set hlsearch            " highlight my search
set incsearch           " incremental search
set wrapscan            " set the search can to wrap around the file

set ignorecase          " when searching
set smartcase           " ..unless I use an uppercase character

set tabstop=4
set softtabstop=0
set expandtab
set shiftwidth=4
set smarttab

set path=$PWD/**        " set path to current directory, for file searching

set exrc                " forcing vim to execute directory-level vimrc
set secure              " block certain actions in directory-level vimrc for security reason (duh)

"setlocal foldmethod=syntax "folding by syntax highlighting

autocmd BufWritePre * :%s/\s\+$//e      " trim whitespace automatically

" cursor appear in its previous position when open files
augroup resCur
  autocmd!
  autocmd BufReadPost * call setpos(".", getpos("'\""))
augroup END

" ----------------------------------------------------------------- "
" Mapping                                                         "
" ----------------------------------------------------------------- "
" use %% to get current directory
cnoremap <expr> %%  getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" temporarily set no search highlight
nnoremap <F2> :noh <CR>
" set spelling checking
nnoremap <F3> :set spell <CR>
nnoremap <F4> :set nospell <CR>
" hide/display column number
nnoremap <F7> :set invnumber <CR>
" open HTML in Chrome
nnoremap <F8> :silent update<Bar>jilent !chromium-browser %:p <CR>
" open HTML in Firefox
nnoremap <F9> :silent update<Bar>silent !firefox %:p <CR>
" map escape to jk
inoremap jk <ESC>

" enable repeating in visual mode
vnoremap . :norm.<CR>

" set localleader
let maplocalleader = "-"

" save file as sudo user
cmap w!! w !sudo tee % > /dev/null %

cmap aa! argadd%
cmap ad! argdelete%

" enable the Rpdf command to read PDF inside vim
:command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk <q-args> - |fmt -csw78

" split into multiple lines base on pattern in normal mode
vnoremap SS :%s//&\r/g<CR>
" USAGE
" - find pattern with /[pattern]
" - high light parts need format
" - run SS

" enable search and replace ALL words under cursor
:nnoremap <Leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>
" USAGE:
"  - \s
"

" -----------------------------------------------------------------
" Aliases
" -----------------------------------------------------------------
:ca F find
:ca FS Files
:ca H help
" common mistakes :)
:ca WQ wq
:ca Wq wq
:ca W w
:ca Q q
:ca Qa qa
:ca QA qa

" ----------------------------------------------------------------- "
" Python/ Django setup
" ----------------------------------------------------------------- "
autocmd FileType python set sw=4
autocmd FileType python set ts=4
autocmd FileType python set sts=4
ab pdb import pdb; pdb.set_trace()
ab ipdb import ipdb; ipdb.set_trace()
ab pprint from pprint import pprint as pp
ab _main if __name__ == '__main__':

" ----------------------------------------------------------------- "
" Tag file
" ----------------------------------------------------------------- "
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" ----------------------------------------------------------------- "
" MarkDown
" ----------------------------------------------------------------- "
autocmd FileType markdown set spell

" ----------------------------------------------------------------- "
" Plugins (lazy.nvim)
" ----------------------------------------------------------------- "
lua << EOF
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
          "ts_ls",           -- TypeScript/JavaScript
          "pyright",         -- Python
          "gopls",           -- Go
          "html",            -- HTML
          "cssls",           -- CSS
          "eslint",          -- ESLint
          "tailwindcss",     -- Tailwind CSS
          "marksman",        -- MarkDown
        },
      })
    end,
  },
  -- LSP Configuration (using new vim.lsp.config API for Nvim 0.11+)
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- Customize LSP server configs (new API)
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

      -- Enable LSP servers (new API)
      vim.lsp.enable("ts_ls")
      vim.lsp.enable("pyright")
      vim.lsp.enable("gopls")
      vim.lsp.enable("html")
      vim.lsp.enable("cssls")
      vim.lsp.enable("tailwindcss")
      vim.lsp.enable("eslint")
      vim.lsp.enable("marksman")

      -- Diagnostic configuration
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

      -- LSP keybindings
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gt", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>fr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
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
  -- nvim-tree: File explorer (NERDTree alternative)
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        sort = { sorter = "case_sensitive" },
        view = { width = 45 },
        renderer = {
          group_empty = true,
          indent_markers = { enable = true },
        },
        filters = {
          dotfiles = false,
          custom = { ".git", "node_modules", ".cache", "__pycache__" },
        },
      })
      -- Keybindings
      vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
      vim.keymap.set("n", "<leader>nf", "<cmd>NvimTreeFindFile<CR>", { desc = "Find file in tree" })
    end,
  },
  -- Telescope fuzzy search
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
      local builtin = require("telescope.builtin")
      -- Keybinding for fuzzy file search
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Fuzzy find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
      -- User command :GF for fuzzy file search
      vim.api.nvim_create_user_command("GF", builtin.find_files, {})
    end,
  },
  -- conform.nvim: Formatting
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
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
      -- Format on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.{go,js,ts,jsx,tsx,json,html,css}",
        callback = function()
          require("conform").format({ async = false, lsp_fallback = true })
        end,
      })
      -- Manual format keybinding
      vim.keymap.set("n", "<leader>fm", function()
        require("conform").format({ async = false, lsp_fallback = true })
      end, { desc = "Format buffer" })
    end,
  },
  -- trouble.nvim: Pretty diagnostics list
  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup()
      vim.keymap.set("n", "<leader>xx", function()
        require("trouble").toggle()
      end, { desc = "Toggle trouble" })
      vim.keymap.set("n", "<leader>xw", function()
        require("trouble").toggle("workspace_diagnostics")
      end, { desc = "Workspace diagnostics" })
      vim.keymap.set("n", "<leader>xd", function()
        require("trouble").toggle("document_diagnostics")
      end, { desc = "Document diagnostics" })
    end,
  },
})
EOF
