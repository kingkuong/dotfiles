" ----------------------------------------------------------------- "
" Vundle config                                                     "
" ----------------------------------------------------------------- "
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')


" ----------------------------------------------------------------- "
" Plugins                                                           "
" ----------------------------------------------------------------- "
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
" list plugins installed with Vundle
Plugin 'flazz/vim-colorschemes'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-fugitive'
Plugin 'pangloss/vim-javascript'
Plugin 'mattn/emmet-vim'
Plugin 'valloric/youcompleteme' "syntax completion
Plugin 'mxw/vim-jsx' "babel syntax highlighting

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
" Vim config                                                        "
" ----------------------------------------------------------------- "
" map escape to jk
inoremap jk <ESC>

" enable repeatation in visual mode
vnoremap . :norm.<CR>

" user setting
set number " display number line
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab " make tabs as 4 spaces

" trim whitespace automatically
if $HOME == '/home/cuongtn'
    autocmd BufWritePre * :%s/\s\+$//e
endif

" ----------------------------------------------------------------- "
" Skeletons                                                         "
" ----------------------------------------------------------------- "
"au BufNewFile *.html 0r ~/.vim/html.skel | let IndentStyle = 'html'


" ----------------------------------------------------------------- "
" Shortcuts                                                         "
" ----------------------------------------------------------------- "
cnoremap <expr> %%  getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" open HTML in Chrome
nnoremap <F8> :silent update<Bar>silent !chromium-browser %:p &<CR>
" open HTML in Firefox
nnoremap <F5> :silent update<Bar>silent !firefox %:p &<CR>


" ----------------------------------------------------------------- "
" Colors                                                            "
" ----------------------------------------------------------------- "

" give us 256 color schemes!"
set term=screen-256color

" color scheme after installing vim-colorschemes
colorscheme wombat256

" ----------------------------------------------------------------- "
" Plugin: NerdTree
" ----------------------------------------------------------------- "
map <C-n> :NERDTreeToggle<CR>

let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

"Use 'I' to toggle hidden files"

let g:NERDTreeShowHidden = 1

function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
    exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
    exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')

" ----------------------------------------------------------------- "
" Plugin: Emmet                                                     "
" ----------------------------------------------------------------- "
" enable emmet only for html, css

let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall

" ----------------------------------------------------------------- "
" Plugin: Vim-JSX                                                   "
" ----------------------------------------------------------------- "
let g:jsx_ext_required = 0 " Allow JSX in normal JS files

" ----------------------------------------------------------------- "
" Python/ Django setup                                              "
" ----------------------------------------------------------------- "
autocmd FileType python set sw=4
autocmd FileType python set ts=4
autocmd FileType python set sts=4
