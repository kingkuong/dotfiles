" ----------------------------------------------------------------- "
" Vundle config
" ----------------------------------------------------------------- "
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" ----------------------------------------------------------------- "
" Plugins installed with Vundle
" ----------------------------------------------------------------- "
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
" list of Github plugins Vundle
Plugin 'flazz/vim-colorschemes'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-fugitive' "git wrapper
Plugin 'pangloss/vim-javascript'
Plugin 'mattn/emmet-vim'
Plugin 'mxw/vim-jsx' "babel syntax highlighting
Plugin 'valloric/MatchTagAlways' "HTML tag highlighting
Plugin 'elixir-lang/vim-elixir' "Syntax highlighting for .eex, .exs, .ex
Plugin 'elzr/vim-json' "Syntax highlighting for Json & JsonP
Plugin 'Yggdroot/indentLine' "View indentation level
Plugin 'mileszs/ack.vim' "Ack searcher

Bundle 'majutsushi/tagbar'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" ----------------------------------------------------------------- "
" Plugins installed with Plug
" ----------------------------------------------------------------- "

" Plug Config
" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
call plug#begin('~/.vim/plugged')

" Initialize plugin system
call plug#end()

" ----------------------------------------------------------------- "
" Vim config                                                        "
" ----------------------------------------------------------------- "
set title               " change the terminal title
set encoding=utf-8      " show utf8-chars
set showcmd             " count highlighted
set ruler               " show where I am in the command area
set number              " display number line
set showmode            " -- INSERT (appreciation)-- :)
set mouse=a             " use the mouse

set cursorline          " highlight current line
set mousehide           " hide the mouse when typing
set backspace=2         " backspace over indent, eol, and insert

set hlsearch            " highlight my search
set incsearch           " incremental search
set wrapscan            " set the search can to wrap around the file

set ignorecase          " when searching
set smartcase           " ..unless I use an uppercase character

set path=$PWD/**        " set path to current directory, for file searching

set tabstop=8
set softtabstop=0
set expandtab
set shiftwidth=4
set smarttab

setlocal foldmethod=syntax "folding by syntax highlighting

autocmd BufWritePre * :%s/\s\+$//e      " trim whitespace automatically
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
cmap ff! find

" enable the Rpdf command to read PDF inside vim
:command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk <q-args> - |fmt -csw78

syntax on

" ----------------------------------------------------------------- "
" Skeletons                                                         "
" ----------------------------------------------------------------- "
au BufNewFile *.html 0r ~/.vim/html.skel | let IndentStyle = 'html'

" ----------------------------------------------------------------- "
" Colors                                                            "
" ----------------------------------------------------------------- "

" give us 256 color schemes!"
set term=screen-256color

" color scheme after installing vim-colorschemes
colorscheme badwolf

" config badwolf
let g:badwolf_darkgutter = 1

" ----------------------------------------------------------------- "
" Plugin: NerdTree
" ----------------------------------------------------------------- "
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

"Use 'I' to toggle hidden files"
let g:NERDTreeShowHidden = 1

" Toggle  NERDTree opening with working file's directory
function! NERDTreeToggleInCurDir()
    " If NERDTree is open in the current buffer
    if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
        exe ":NERDTreeClose"
    else
        "If there's current file
        if (expand("%:t") != '')
            exe ":NERDTreeFind"
        else
            exe ":NERDTreeToggle"
        endif
    endif
endfunction

" Function to highlight different extensions
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
    exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
    exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction
call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')

" NERDTree Mapping
map <C-n> :call NERDTreeToggleInCurDir()<CR>

" ----------------------------------------------------------------- "
" Plugin: Emmet
" ----------------------------------------------------------------- "
" enable emmet only for html, css
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall

" ----------------------------------------------------------------- "
" Plugin: Vim-JSX
" ----------------------------------------------------------------- "
let g:jsx_ext_required = 0 " Allow JSX in normal JS files

" ----------------------------------------------------------------- "
" Plugin: TagBar
" ----------------------------------------------------------------- "
"let g:tagbar_width=26                          " Default is 40, seems too wide
nmap <F6> :TagbarToggle<CR>

" ----------------------------------------------------------------- "
" Plugin: vim-json
" ----------------------------------------------------------------- "
set conceallevel=2

" ----------------------------------------------------------------- "
" Plugin: indent-line
" ----------------------------------------------------------------- "
let g:indentLine_noConcealCursor=""

" ----------------------------------------------------------------- "
" Plugin: ack.vim
" ----------------------------------------------------------------- "
" To use Ag instead
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

" ----------------------------------------------------------------- "
" Python/ Django setup
" ----------------------------------------------------------------- "
autocmd FileType python set sw=4
autocmd FileType python set ts=4
autocmd FileType python set sts=4
ab pdb import pdb; pdb.set_trace()
ab ipdb import ipdb; ipdb.set_trace()
ab _main if __name__ == '__main__':

" ----------------------------------------------------------------- "
" tag file TODO: more about this
" ----------------------------------------------------------------- "
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" ----------------------------------------------------------------- "
" MarkDown
" ----------------------------------------------------------------- "
autocmd FileType mkd set spell

" ----------------------------------------------------------------- "
" Pathogen
" ----------------------------------------------------------------- "
execute pathogen#infect()
" List of Pathogen installed Plugin:
" - speeddating
" - unimpaired
" - YouCompleteMe
"   **Quick Guide**
"       - cd ~/.vim/bundle
"       - git clone https://github.com/Valloric/YouCompleteMe.git
"       - git submodule update --init --recursive
"       - Make sure these libraries are installed
"           sudo apt-get install build-essential cmake
"           sudo apt-get install python-dev python3-dev
"           node/npm
"       This will install YCM with syntax support for C-family language,
"               Python and Javascript
"       - ./install.py --clang-completer --tern-completer
