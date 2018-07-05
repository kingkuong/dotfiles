" ----------------------------------------------------------------- "
" Plugins installed with Plug
" ----------------------------------------------------------------- "
" Automatic installation of Vim-Plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Plugin list
Plug 'elixir-lang/vim-elixir',                  {'for': 'elixir'}
Plug 'elzr/vim-json',                           {'for': 'json'} " Syntax highlighting for Json & JsonP
Plug 'flazz/vim-colorschemes'
Plug 'jceb/vim-orgmode',                        {'for': 'org'} " Orgmode's in Vim, who needs emacs
Plug 'junegunn/goyo.vim',                       {'on': 'Goyo'} " Distraction-free writing
Plug 'majutsushi/tagbar'
Plug 'mattn/emmet-vim',                         {'for': 'html'}
Plug 'mileszs/ack.vim'                          " Ack searcher, require to have Ag installed if want to search using Ag
Plug 'mxw/vim-jsx',                             {'for': 'jsx'}
Plug 'pangloss/vim-javascript',                 {'for': 'javascript'}
Plug 'plasticboy/vim-markdown',                 {'for': 'markdown'}
Plug 'posva/vim-vue'
Plug 'scrooloose/nerdtree',                     {'on': ['NERDTreeToggle', 'NERDTreeClose', 'NERDTreeFind']}
Plug 'slashmili/alchemist.vim'                  " Elixir integration
Plug 'tpope/vim-fugitive'                       " Git wrapper
Plug 'tpope/vim-sensible'                       " Agreeable vim configs
Plug 'tpope/vim-speeddating'                    " Date objects
Plug 'tpope/vim-unimpaired'                     " Convenient configs
Plug 'valloric/MatchTagAlways',                 {'for': 'html'} " HTML tag highlighting
Plug 'vim-airline/vim-airline'                  " Light & simple status bar
Plug 'vim-airline/vim-airline-themes'           " Status Bar theme
Plug 'yggdroot/indentLine'                      " View indentation level
Plug 'w0rp/ale'                                 " Vim 8's Async linter

" Plugins to checkout
"Plug 'suan/vim-instant-markdown'

function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    !./install.py --clang-completer --tern-completer --js-completer
  endif
endfunction
Plug 'valloric/YouCompleteMe', { 'do': function('BuildYCM') }

call plug#end()
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

" Enable if have terminal with fast drawing
"set cursorcolumn        " vertical highlight
"set cursorline          " horizontal highlight

set ttyfast             " re-drawing instead of scrolling
set ttyscroll           " re-drawing instead of scrolling when scrolling 3 lines consecutively
set lazyredraw
set ttimeoutlen=100

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

" -----------------------------------------------------------------
" Skeletons
" -----------------------------------------------------------------
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
let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeMinimalUI = 1
let g:NERDTreeAutoDeleteBuffer = 1

"Use 'I' to toggle hidden files"
let g:NERDTreeShowHidden = 1

" NERDTree Ignore List
let g:NERDTreeIgnore = ['.pyc$', '.ropeproject', '__pycache__']

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

map <C-n> :call NERDTreeToggleInCurDir()<CR>

" Function to highlight different extensions
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
    exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
    exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
call NERDTreeHighlightFile('py', 'Green', 'none', 'green', '#151515')

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
    let g:ackprg = 'ag --vimgrep --smart-case'

endif

" ----------------------------------------------------------------- "
" Plugin: vim-airline
" ----------------------------------------------------------------- "
let g:airline_powerline_fonts=1
let g:airline_theme='dark_minimal'

" ----------------------------------------------------------------- "
" Plugin: vim-markdown
" ----------------------------------------------------------------- "
let g:vim_markdown_folding_disabled=0
let g:vim_markdown_folding_level=6
let g:vim_markdown_new_list_item_indent=2

" ----------------------------------------------------------------- "
" Plugin: Goyo
" ----------------------------------------------------------------- "
let g:goyo_width = 100
let g:goyo_height = 95

" ----------------------------------------------------------------- "
" Plugin: ale
" ----------------------------------------------------------------- "
let g:ale_fix_on_save = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_delay = 500
let g:ale_lint_on_insert_leave = 1
" Ale requires these tools to be installed globally
let g:ale_fixers = {
            \'python': ['autopep8'],
            \'javascript': ['prettier'],
            \}
let g:ale_linters = {
            \'python': ['pylint'],
            \'javascript': ['eslint'],
            \}

" ----------------------------------------------------------------- "
" Plugin: vim-orgmode
" ----------------------------------------------------------------- "
let g:org_todo_keywords = ['TODO', 'DOING', '|', 'UNCOMPLETED', 'DONE', 'CANCELLED']

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
" Tag file
" ----------------------------------------------------------------- "
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" ----------------------------------------------------------------- "
" MarkDown
" ----------------------------------------------------------------- "
autocmd FileType markdown set spell
