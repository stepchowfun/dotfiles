" Begin vim-plug
call plug#begin('~/.local/share/nvim/plugged')

" base16-vim
Plug 'chriskempson/base16-vim'

" deoplete
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" easymotion
Plug 'easymotion/vim-easymotion'

" fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" nerdtree
Plug 'scrooloose/nerdtree'

" vim-airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" vim-fugitive
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

" Better syntax highlighting for C++
Plug 'octol/vim-cpp-enhanced-highlight'

" vim-tmux-navigator
Plug 'christoomey/vim-tmux-navigator'

" End vim-plug
call plug#end()

" Set the leader to ,.
let mapleader = ","

" Load the current base16-vim color scheme.
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace = 256

  " We have silent! here because this will only succeed once the base16-vim
  " plugin is installed.
  silent! source ~/.vimrc_background
endif

" Start nerdtree automatically on startup if no files were specified.
autocmd StdinReadPre * let s:std_in = 1
autocmd VimEnter * if exists(':NERDTree') && argc() == 0 && !exists("s:std_in") | NERDTree | wincmd l | endif

" Close neovim automatically if the only window left open is nerdtree.
autocmd bufenter * if exists(':NERDTree') && (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Show hidden files in nerdtree.
let NERDTreeShowHidden = 1

" Disable default easymotion bindings.
let g:EasyMotion_do_mapping = 0

" Use s to jump to any character with easymotion.
nmap s <Plug>(easymotion-overwin-f)

" Use <Leader>j and <Leader>k to jump to a line with easymotion.
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" For opening files with fzf.
map <C-p> :Files<CR>

" The vim-tmux-navigator documentation recommends the following hack
" to get around a bug in macOS's terminfo for xterm-256color.
nnoremap <silent> <BS> :TmuxNavigateLeft<CR>

" Set the airline theme.
let g:airline_theme = 'base16'
let g:airline_powerline_fonts = 1

" Clear highlighting with Esc.
nnoremap <esc> :noh<return><esc>

" Turn on mouse mode
set mouse=a

" Show line numbers.
set number

" Insert spaces instead of tabs.
set expandtab

" Use two spaces for indentation.
set shiftwidth=2

" Don't auto-indent anything
set indentexpr=

" Show the line and column numbers of the cursor position.
set ruler

" Disable beeps.
set noerrorbells visualbell t_vb=

" Use the primary clipboard.
set clipboard=unnamed

" Set the highlight color for trailing whitespace.
highlight TrailingWhitespace ctermbg=red guibg=red

" Highlight trailing whitespace.
match TrailingWhitespace '\s\+$\|\n\+\%$'

" Wrap lines at word boundaries and make the wrapping more obvious.
set showbreak=..
set breakindent
set breakindentopt=shift:2,sbr

" Turn on spell checking everywhere.
set spell spelllang=en_us
syntax spell toplevel
autocmd Syntax * :syntax spell toplevel

" Custom file type mappings
autocmd BufNewFile,BufRead *.hql set syntax=sql
autocmd BufNewFile,BufRead *.txt set syntax=ruby

" Load any system local configuration
silent! source ~/.vimrc-local
