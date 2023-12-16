"""""""""""
" Plugins "
"""""""""""

call plug#begin('~/.local/share/nvim/plugged')
  " Support for base16 color themes
  Plug 'chriskempson/base16-vim'

  " A nice file system explorer
  Plug 'scrooloose/nerdtree'

  " Fuzzy search
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'

  " A nice status line
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  " Git integration
  Plug 'tpope/vim-fugitive'

  " GitHub integration
  Plug 'tpope/vim-rhubarb'

  " Show which lines have changed using Git.
  Plug 'airblade/vim-gitgutter'

  " Switch between windows in the same way as switching between tmux panes.
  Plug 'christoomey/vim-tmux-navigator'
call plug#end()

""""""""""""""""""""""""
" Plugin configuration "
""""""""""""""""""""""""

" PLUGIN: Base16 Vim

" Load the current base16-vim color scheme.
if exists('$BASE16_THEME')
      \ && (!exists('g:colors_name') || g:colors_name != 'base16-$BASE16_THEME')
    let base16colorspace=256
    colorscheme base16-$BASE16_THEME
endif

" PLUGIN: NERDTree

" Start NERDTree automatically on startup if no files were specified.
autocmd StdinReadPre * let s:std_in = 1
autocmd VimEnter * if exists(':NERDTree') && argc() == 0 && !exists("s:std_in") | NERDTree | wincmd l | endif

" Close Neovim automatically if the only window left open is nerdtree.
autocmd bufenter * if exists(':NERDTree') && (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" PLUGIN: fzf

" Show hidden files in NERDTree.
let NERDTreeShowHidden = 1

" Use C-p to open files with fzf
nmap <silent> <C-p> :Files<CR>

" PLUGIN: vim-airline

" Set the airline theme.
let g:airline_theme = 'base16'
let g:airline_powerline_fonts = 1

" PLUGIN: Vim Tmux Navigator

" The vim-tmux-navigator documentation recommends the following hack
" to get around a bug in macOS's terminfo for xterm-256color.
nmap <silent> <BS> :TmuxNavigateLeft<CR>

""""""""""""""""""""
" General settings "
""""""""""""""""""""

" Clear highlighting with Esc.
nmap <silent> <esc> :noh<return>

" Turn on mouse mode.
set mouse=a

" Show line numbers.
set number

" Show the line and column numbers of the cursor position.
set ruler

" Disable beeps.
set noerrorbells visualbell t_vb=

" Use the primary clipboard.
set clipboard=unnamedplus

" Set the highlight color for trailing whitespace.
highlight TrailingWhitespace ctermbg=red guibg=red

" Highlight trailing whitespace.
match TrailingWhitespace '\s\+$\|\n\+\%$'

" Wrap lines at word boundaries, make the wrapping more obvious, and make
" cursor movement more intuitive.
set showbreak=..
set breakindent
set breakindentopt=shift:2,sbr
nmap <silent> k gk
nmap <silent> j gj

" Turn on spell checking everywhere.
set spell spelllang=en_us
syntax spell toplevel
autocmd Syntax * syntax spell toplevel | hi clear SpellBad | hi SpellBad cterm=underline | hi clear SpellCap | hi SpellCap cterm=underline | hi clear SpellLocal | hi SpellLocal cterm=underline

" Use the same indentation settings regardless of file type.
autocmd BufNewFile,BufRead * set expandtab | set shiftwidth=2 | set softtabstop=2

" ...except for Rust source files.
autocmd BufNewFile,BufRead *.rs set shiftwidth=4 | set softtabstop=4

"""""""""""""""""""""""
" Local configuration "
"""""""""""""""""""""""

" Load any system local configuration.
silent! source ~/.vimrc-local
