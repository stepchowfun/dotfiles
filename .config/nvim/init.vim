" Begin vim-plug
call plug#begin('~/.local/share/nvim/plugged')

" base16-vim
Plug 'chriskempson/base16-vim'

" LanguageClient
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
let g:LanguageClient_serverCommands = {
    \ 'haskell': ['hie-wrapper'],
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ }

" deoplete
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
let g:deoplete#enable_at_startup = 1

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

" vim-gitgutter
Plug 'airblade/vim-gitgutter'

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
nmap <silent> s <Plug>(easymotion-overwin-f)

" Use <Leader>j and <Leader>k to jump to a line with easymotion.
nmap <silent> <Leader>j <Plug>(easymotion-j)
nmap <silent> <Leader>k <Plug>(easymotion-k)

" For opening files with fzf.
nmap <silent> <C-p> :Files<CR>

" The vim-tmux-navigator documentation recommends the following hack
" to get around a bug in macOS's terminfo for xterm-256color.
nmap <silent> <BS> :TmuxNavigateLeft<CR>

" LanguageClient shortcuts
nmap <silent> K :call LanguageClient#textDocument_hover()<CR>
nmap <silent> gd :call LanguageClient#textDocument_definition()<CR>

" Set the airline theme.
let g:airline_theme = 'base16'
let g:airline_powerline_fonts = 1

" Clear highlighting with Esc.
nmap <silent> <esc> :noh<return>

" Turn on mouse mode
set mouse=a

" Show line numbers.
set number

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
nmap <silent> k gk
nmap <silent> j gj

" Turn on spell checking everywhere.
set spell spelllang=en_us
syntax spell toplevel
autocmd Syntax * :syntax spell toplevel

" Indentation options
function SetIndentationOptions()
  " Insert spaces instead of tabs.
  set expandtab

  " Use two spaces for indentation.
  set shiftwidth=2
  set softtabstop=2
endfunction

" Custom file type mappings
autocmd BufNewFile,BufRead *.hql set syntax=sql
autocmd BufNewFile,BufRead *.txt set syntax=ruby

" Use the same indentation settings regardless of file type.
autocmd BufNewFile,BufRead * call SetIndentationOptions()

" Load any system local configuration.
silent! source ~/.vimrc-local
