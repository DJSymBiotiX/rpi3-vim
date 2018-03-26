" ----------------------------
" VIM Behavior
" ----------------------------

set isfname-==                  " Don't allow completion of filenames wit hthe '=' character
set encoding=utf-8              " Use unicode from within vim
set nocompatible                " Vim behaves more usefully
set noautochdir                 " Don't automatically place vim in working dir of any opened files
set hidden                      " Allow opening of new buffers without saving old buffer
set noerrorbells                " Quit with your beeping
set laststatus=2                " Always show line status
set backspace=indent,eol,start  " Let backspace work anywhere in insert mode
set nonumber                    " Don't show line numbers
set cursorline                  " Highlight the active editor line
set scrolloff=10                " Ensure at least 10 lines are always visible below the cursor
set cmdheight=1                 " Show only a single line of command line history
syntax on                       " Enable syntax highlighting
filetype on                     " detect file being edited
set linespace=0                 " No extra whitespace between lines in requires

" Indent Settings
set expandtab                   " Expand tabs to spaces
set tabstop=4                   " Use 4 spaces on a tab
set smarttab                    " Round to nearest tab on tab
set shiftwidth=4                " Use 4 spaces on <<, >>
set shiftround                  " Round to nearest tab on <<, >>
filetype plugin indent on       " Enable per-filetype indent settings

" Search Settings
set incsearch                   " Use incremental search mode
set nohls                       " Disable highlight search mode
set ignorecase                  " Ignore case by default on searches
set smartcase                   " Unless I explicitly type uppercase, then match it

" Persistent Undo Settings
set undodir=~/.vim/tmp/undo/
set undofile
set undolevels=1000
set undoreload=10000

" Keep backups in /tmp
set backupdir=~/.vim/tmp/backup/
set backup
set directory=~/.vim/tmp/swap/

" Set molokai color scheme
colors molokai
set background=dark
highlight ColorColumn ctermbg=red

" Use the system clipboard (Allows sharing between multiple vim instances)
set clipboard=unnamed

" Add a command to write as sudo if you forget to open as sudo
command! Sw :w !sudo tee % > /dev/null

" ----------------------------
" Console Tweaks
" ----------------------------
function! MapKeycode(intermediate, key, keycode)
    " Based on http://vim.wikia.com/wiki/Mapping_fast_keycodes_in_terminal_Vim
    " Vim doesn't allow you to say set <M-up>=Escaped Code
    " You must first set another intermediate, then map the command to m-up
    exec 'set '.a:intermediate.'='.a:keycode
    exec 'map '.a:intermediate.' '.a:key
    exec 'imap '.a:intermediate.' '.a:key
endfunction

" Enable the mouse
set mouse=a
set ttymouse=xterm2
set t_Co=256

if &term == "screen-256color"
    " Remap the alt+arrows to the ones we get from screen
    call MapKeycode('<F13>', '<M-Up>',     '^[[1;3A')
    call MapKeycode('<F14>', '<M-Down>',   '^[[1;3B')
    call MapKeycode('<F15>', '<M-Left>',   '^[[1;3D')
    call MapKeycode('<F16>', '<M-Right>',  '^[[1;3C')
    call MapKeycode('<F17>', '<S-Up>',     '^[[1;2A')
    call MapKeycode('<F18>', '<S-Down>',   '^[[1;2B')
    call MapKeycode('<F19>', '<S-Left>',   '^[[1;2D')
    call MapKeycode('<F20>', '<S-Right>',  '^[[1;2C')
endif

" ----------------------------
" Highlights
" ----------------------------
match SpellBad /\s\+$/ " Highlight Dangling Whitespace

" ----------------------------
" Paste Strats
" ----------------------------
function! WrapForTmux(s)
    if !exists('$TMUX')
        return a:s
    endif

    let tmux_start = "\<Esc>Ptmux;"
    let tmux_end = "\<Esc>\\"

    return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin()
    set pastetoggle=<Esc>[201~
    set paste
    return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

" ----------------------------
" Plugin Settings
" ----------------------------

" Powerline Settings
set noshowmode                          " Disable default editor mode
let g:Powerline_symbols='unicode'       " Tell Powerline to use patched font

" ale Settings
let g:ale_linters = {
    \ 'javascript': ['eslint'],
    \ 'python': ['flake8']
\}

" Editorconfig
let g:EditorConfig_core_mode='external_command'

" ----------------------------
" Key Bindings
" ----------------------------

" Ctrl + f does recursive grep on current word
nmap <C-f> :vimgrep <cword> *.*<cr>:copen<cr>

" Map ; to : so holding shift doesn't mess up command mode
nore ; :

" Ctrl + h toggles highlight search
function! ToggleHLSearch()
    " Toggle the hls setting
    if &hls
        set nohls
    else
        set hls
    endif
endfunction
map <silent> <C-h> <Esc>:call ToggleHLSearch()<CR>
