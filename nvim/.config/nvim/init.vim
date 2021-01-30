if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'godlygeek/tabular'
  Plug 'gruvbox-community/gruvbox'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

set guicursor=
set relativenumber
set nohlsearch
set noerrorbells
set shiftwidth=4
set softtabstop=4
set tabstop=4 
set expandtab
set smartindent
set nu
set nowrap
set smartcase
set noswapfile
set noundofile
set incsearch
set termguicolors
set scrolloff=8
set noshowmode
set completeopt=menuone,noinsert,noselect
set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey

let mapleader = " "

" Easily resize split windows with Ctrl+hjkl
nnoremap <C-j> <C-w>+
nnoremap <C-k> <C-w>-
nnoremap <C-h> <C-w><
nnoremap <C-l> <C-w>>

" Reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv

" Move by screen lines instead of file line
nnoremap j gj
nnoremap k gk

" Join lines from below too. See :help J
map K kJ

" Make Y behave like other capitals
map Y y$

" Select another file from the directory of the current one
nnoremap <leader>F :execute 'edit' expand("%:p:h")<cr>

"--- code completion
set cmdheight=2
set hidden
set nobackup
set nowritebackup
set shortmess+=c
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
set updatetime=50

" tab complete
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

"--- colorscheme
colorscheme gruvbox
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_invert_selection='0'
set background=dark

"--- ctrl-p
let g:ctrlp_switch_buffer = 'et'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

"--- netrw
let g:NetrwIsOpen=0
let g:netrw_banner = 0
let g:netrw_winsize = 15               
let g:netrw_browse_split = 2
let g:netrw_winsize = 20
let g:netrw_localrmdir='rm -r'
let g:netrw_dirhistmax = 0

function! ToggleNetrw()
    if g:NetrwIsOpen
        let i = bufnr("$")
        while (i >= 1)
            if (getbufvar(i, "&filetype") == "netrw")
                silent exe "bwipeout " . i 
            endif
            let i-=1
        endwhile
        let g:NetrwIsOpen=0
    else
        let g:NetrwIsOpen=1
        silent Lexplore
    endif
endfunction

noremap <silent> <C-E> :call ToggleNetrw()<CR>
