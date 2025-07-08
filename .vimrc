
" Basic settings
set nocompatible              " Use Vim settings, not Vi settings
filetype plugin indent on     " Enable file type detection and plugins
syntax enable                 " Enable syntax highlighting
set encoding=utf-8            " Use UTF-8 encoding
set number                    " Show line numbers
set relativenumber            " Show relative line numbers
set showmatch                 " Show matching brackets
set ignorecase                " Ignore case in searches
set smartcase                 " Don't ignore case with capitals
set hlsearch                  " Highlight search results
set incsearch                 " Incremental search
set expandtab                 " Use spaces instead of tabs
set smartindent
set shiftwidth=4              " Use 4 spaces for indentation
set tabstop=4                 " Show tabs as 4 spaces
set scrolloff=8               " Keep 8 lines above/below cursor
set mouse=a                   " Enable mouse support
set termguicolors             " Enable true colors
set clipboard=unnamed         " Use system clipboard
set hidden                    " Allow buffers to be hidden
set noswapfile                " Don't use swap files
set nobackup                  " Don't create backup files
set undofile                  " Persistent undo
set undodir=~/.vim/undodir    " Set undo directory
set signcolumn=yes            " Always show sign column
set updatetime=50
set nocursorline " Neovim's cursorline is false, so setting it to nocursorline in Vim

" set smoothscroll " Not a standard Vim option
set grepprg=rg\ --vimgrep


" Folding
set foldenable
set foldtext=
set foldlevel=99
set foldlevelstart=99



" Create undo directory if it doesn't exist
if !isdirectory($HOME.'/.vim/undodir')
    call mkdir($HOME.'/.vim/undodir', 'p')
endif

" Leader key settings
let mapleader = " "
let maplocalleader = "\\"

" Plugins using vim-plug (install it first: https://github.com/junegunn/vim-plug)
" Auto-install vim-plug if not present
let data_dir = '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
" File explorer (like Oil)
Plug 'preservim/nerdtree'

" Fuzzy finder (like Telescope)
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Git integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Status line
Plug 'vim-airline/vim-airline'


" Auto pairs
Plug 'jiangmiao/auto-pairs'

" Simple commenting
Plug 'tpope/vim-commentary'

" Surround text
Plug 'tpope/vim-surround'
call plug#end()


colorscheme default

" NERDTree settings (Oil-like file explorer)
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = ['.DS_Store', '__pycache__', '.git']
nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap - :NERDTreeFind<CR>
" Close vim if NERDTree is the only window remaining
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" FZF settings (Telescope-like fuzzy finder)
" Files finder
nnoremap <leader><leader> :Files<CR>
nnoremap <leader>ff :Files<CR>
" Git files finder
" nnoremap <leader>fg :GFiles<CR>
" Buffer finder
nnoremap <leader>b :Buffers<CR>
" Live grep
nnoremap <leader>fg :Rg<CR>
" Help tags
nnoremap <leader>fh :Helptags<CR>

" Buffer navigation (similar to your neovim config)
nnoremap <S-h> :bprevious<CR>
nnoremap <S-l> :bnext<CR>
nnoremap <C-x> :bdelete<CR>

" Window navigation
" Move to window using the <ctrl> hjkl keys
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Terminal Mappings
noremap <leader>T :term<CR>
tnoremap <esc> <C-\\><C-n>
tnoremap <C-h> <C-w>h
tnoremap <C-j> <C-w>j
tnoremap <C-k> <C-w>k
tnoremap <C-l> <C-w>l
tnoremap <C-/> :close<CR>

" Window splits
nnoremap <leader>w- :split<CR>
nnoremap <leader>w\| :vsplit<CR>
nnoremap <leader>wx :close<CR>

" Clear search highlight with ESC
nnoremap <silent> <Esc> :noh<CR>
inoremap <esc> :noh<CR><esc>
noremap <esc> :noh<CR><esc>

" Move lines up and down (like your neovim config)
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Resize window using <option> arrow keys (using <A-> for Alt, may vary by terminal)
noremap <A-Up> :resize +2<CR>
noremap <A-Down> :resize -2<CR>
noremap <A-Left> :vertical resize -2<CR>
noremap <A-Right> :vertical resize +2<CR>

" keywordprg
noremap <leader>cK :norm! K<CR>

" Better indenting in visual mode
vnoremap < <gv
vnoremap > >gv

" Highlight on yank
if exists('##TextYankPost')
  autocmd TextYankPost * silent! lua vim.highlight.on_yank()
endif


" Autocmds
augroup vimrc_autocmds
    autocmd!

    " Check if we need to reload the file when it changed
    autocmd FocusGained * if &buftype != 'nofile' | checktime | endif

    " Highlight on yank (requires a plugin or custom function in Vimscript)
    " autocmd TextYankPost * silent! call system('sleep 0.1 | xclip -selection clipboard -i') " Example for xclip

    " Resize splits if window got resized
    autocmd VimResized * tabdo wincmd =

    " Terminal options (basic translation)
    autocmd BufWinEnter * if &buftype == 'terminal' | setlocal nonumber norelativenumber scrolloff=0 | endif

    " Fix conceallevel for json files
    autocmd FileType json,jsonc,json5 setlocal conceallevel=0

    " Close some filetypes with <q> (basic translation, may not handle all cases)
    autocmd FileType oil,PlenaryTestPopup,checkhealth,dbout,gitsigns-blame,grug-far,help,lspinfo,neotest-output,neotest-output-panel,neotest-summary,notify,qf,spectre_panel,startuptime,tsplayground setlocal buflisted=0 | nnoremap <buffer> q :close<CR>

    " Make copilot-chat buffers unlisted (cannot be fully replicated without Copilot plugin)
    " autocmd BufAdd * if expand('%:t') =~ 'copilot-chat' | setlocal nobuflisted | endif

    " FileType specific options for JS/TS/JSON
    autocmd FileType javascript,javascriptreact,typescript,typescriptreact,json setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
augroup END

