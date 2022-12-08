"*****************************************************************************
" Plugins
"*****************************************************************************
let vimplug=expand('~/.vim/autoload/plug.vim')
let curl=expand('curl')
if !filereadable(vimplug)
  if !executable(curl)
    echoerr "ERROR: curl not found"
    execute "q!"
  endif
  echo "--- installing vim-plug..."
  echo ""
  silent exec "!"curl" -fLo " . shellescape(vimplug) . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  let g:not_finish_vimplug = "yes"
  autocmd VimEnter * PlugInstall
endif
" Required:
call plug#begin(expand('~/.vim/plugged'))
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'airblade/vim-gitgutter'
Plug 'vim-scripts/grep.vim'
Plug 'Yggdroot/indentLine'
Plug 'Raimondi/delimitMate'
Plug 'editor-bootstrap/vim-bootstrap-updater'
Plug 'tomasiser/vim-code-dark'
call plug#end()
" Required:
filetype plugin indent on
"*****************************************************************************
" Options
"*****************************************************************************
let mapleader=','
set backspace=indent,eol,start
set encoding=utf-8
set expandtab
set fileencoding=utf-8
set fileencodings=utf-8
set fileformats=unix,dos,mac
set hidden
set hlsearch
set ignorecase
set incsearch
set shiftwidth=2
set smartcase
set softtabstop=0
set tabstop=4
set ttyfast
let zsh=expand('zsh')
if !executable(zsh)
    set shell=zsh
else
    set shell=/bin/bash
endif
let g:indentLine_char_list = '|'
"*****************************************************************************
" Visual Settings
"*****************************************************************************
syntax on
set ruler
set number
let no_buffers_menu=1
colorscheme codedark
set wildmenu
set mouse=a
set mousemodel=popup
set t_Co=256
set guioptions=egmrti
set gfn=Monospace\ 10
if &term =~ '256color'
  set t_ut=
endif
set gcr=a:blinkon0
set scrolloff=3
set laststatus=2
set modeline
set modelines=10
set title
set titleold="Terminal"
set titlestring=%F
set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\
" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv
if exists("*fugitive#statusline")
  set statusline+=%{fugitive#statusline()}
endif
"*****************************************************************************
" Abbreviations
"*****************************************************************************
" no one is really happy until you have this shortcuts
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall
" NERDTree configuration
let g:NERDTreeChDirMode=2
let g:NERDTreeIgnore=['node_modules','\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']
let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
let g:NERDTreeShowBookmarks=1
let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
let g:NERDTreeWinSize = 50
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite,*node_modules/
nnoremap <silent> <C-n> :NERDTreeToggle<CR>
" grep.vim
nnoremap <silent> <leader>f :Rgrep<CR>
let Grep_Default_Options = '-IR'
let Grep_Skip_Files = '*.log *.db'
let Grep_Skip_Dirs = '.git node_modules'
" terminal emulation
nnoremap <silent> <leader>sh :terminal<CR>
" remove trailing whitespaces
command! FixWhitespace :%s/\s\+$//e
if !exists('*s:setupWrapping')
  function s:setupWrapping()
    set wrap
    set wm=2
    set textwidth=79
  endfunction
endif
" The PC is fast enough, do syntax highlight syncing from start unless 200 lines
augroup vimrc-sync-fromstart
  autocmd!
  autocmd BufEnter * :syntax sync maxlines=3000
augroup END
" Remember cursor position
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END
" txt
augroup vimrc-wrapping
  autocmd!
  autocmd BufRead,BufNewFile *.txt call s:setupWrapping()
augroup END
set autoread
"*****************************************************************************
" Mappings
"*****************************************************************************
" Split
noremap <Leader>h :<C-u>split<CR>
noremap <Leader>v :<C-u>vsplit<CR>
" Tabs
nnoremap <Tab> gt
nnoremap <S-Tab> gT
nnoremap <silent> <S-t> :tabnew<CR>
" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>
cnoremap <C-P> <C-R>=expand("%:p:h") . "/" <CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>e :FZF -m<CR>
"Recovery commands from history through FZF
nmap <leader>y :History:<CR>
" Disable visualbell
set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif
" Copy/Paste/Cut
if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
endif
noremap YY "+y<CR>
noremap <leader>p "+gP<CR>
noremap XX "+x<CR>
if has('macunix')
  " pbcopy for OSX copy/paste
  vmap <C-x> :!pbcopy<CR>
  vmap <C-c> :w !pbcopy<CR><CR>
endif
" Buffer nav
nnoremap <silent> <S-h> :bprevious<CR>
nnoremap <silent> <S-l> :bnext<CR>
" Close buffer
noremap <leader>c :bd<CR>
" Clean search (highlight)
nnoremap <silent> <leader><space> :noh<cr>
" Switching windows
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h
"" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv
"" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" vim: ft=vim sw=2 ts=2 et :
