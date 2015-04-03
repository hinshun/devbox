" Set augroup
augroup auglobal
  autocmd!
augroup END

" Turn on automatic indentation
filetype plugin indent on

" Enable syntax
syntax enable

"===============================================================================
" Plugins
"===============================================================================

silent! if plug#begin('~/.vim/plugged')

" Colors
Plug 'hinshun/vim-tomorrow-theme'

" Status
Plug 'bling/vim-airline'

" Edit
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-commentary'
Plug 'lokaltog/vim-easymotion'
Plug 'osyo-manga/vim-over'
Plug 'junegunn/vim-easy-align'
Plug 'sjl/gundo.vim', { 'on': 'GundoToggle' }

" Browsing
Plug 'kien/ctrlp.vim'
Plug 'FelikZ/ctrlp-py-matcher'
Plug 'rking/ag.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'bogado/file-line'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Lang
Plug 'scrooloose/syntastic'
if v:version >= 703
  Plug 'vim-ruby/vim-ruby'
endif
Plug 'tpope/vim-rails'
Plug 'pangloss/vim-javascript'
Plug 'kchmck/vim-coffee-script'
Plug 'plasticboy/vim-markdown'
Plug 'mustache/vim-mustache-handlebars'

call plug#end()
endif

"===============================================================================
" General Settings
"===============================================================================

" Set default shell
set shell=/bin/sh

" Disable splash screen
set shortmess+=I

" Initialize colorscheme if loaded
silent! colorscheme Tomorrow-Night

" Turn on line number
set number

" Always splits to the right and below
set splitbelow
set splitright

" Turn off sound
set vb
set t_vb=

" Show current mode
set showmode

" Lower the delay of escaping out of other modes
set timeout timeoutlen=200 ttimeoutlen=1

" Turn backup off
set nobackup
set nowritebackup
set noswapfile

" Highlight current line cursor is on
set cursorline

" Show the current command being inputted
set showcmd

" Set to auto read when a file is changed from the outside
set autoread

" Minimal number of screen lines to keep above and below the cursor
set scrolloff=10

" Min width of the number column to the left
set numberwidth=1

" Open all folds initially
set foldmethod=indent   	        " fold by indent level
set nofoldenable        	        " dont fold by default

" Set level of folding
set foldlevel=1        	          " start folding for level

" Allow changing buffer without saving it first
set hidden

" Set backspace config
set backspace=eol,start,indent

" Case insensitive search
set ignorecase
set smartcase

" Incremental search
set incsearch

" Highlight search
set hlsearch

" Make regex a little easier to type
set magic

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Tab settings
set tabstop=2                     " width of tab
set shiftwidth=2                  " shifting >>, <<, ==
set softtabstop=2                 " tab key <TAB>, <BS>
set expandtab	                    " always use softtabstop for <TAB>
set smartindent

" Text display settings
set autoindent
set linebreak
" set textwidth=80

" Wild menu settings
set wildmode=list:longest,full
set wildmenu "turn on wild menu
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=*.so,*.swp,*.zip,*/.Trash/**,*.pdf,*.dmg,*/Library/**,*/.rbenv/**
set wildignore+=*/.nx/**,*.app

"===============================================================================
" Leader Key Mappings
"===============================================================================

" Map leader to space
let mapleader = " "
let g:mapleader = " "
let maplocalleader = " "
let g:maplocalleader = " "

" <Leader>y: Copy to system clipboard
map <leader>y "*y

" <Leader>/: Clear highlighted searches
nnoremap <Leader>/ :nohlsearch<cr>

" <C-p>: Ctrl-P file searching
nnoremap <leader>ct :CtrlPTag<cr>

" <Leader>pi: Installs Plugins
map <leader>pi :PlugInstall<cr>

" <Leader>ps: Displays the status of Plugins
map <leader>ps :PlugStatus<cr>

" <Leader>nt: Toggle NERDTree
nnoremap <Leader>nt :NERDTreeToggle<cr>

" <Leader>ag: Ag content searching
nnoremap <Leader>ag :Ag<space>

" <Leader>o: Open current file in Google Chrome
nnoremap <Leader>o :exe '!open -a "/opt/homebrew-cask/Caskroom/google-chrome/latest/Google Chrome.app/" %'<cr>:redraw!<cr>

"===============================================================================
" Non-leader Key Mappings
"===============================================================================

" <C-c>: <ESC>
inoremap <C-c> <esc>

" Tab completion
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>

" Jump through Quickfix results
nmap <silent> ]q :cnext<CR>
nmap <silent> [q :cprev<CR>

"===============================================================================
" Functions
"===============================================================================

function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction

"===============================================================================
" Autocommands
"===============================================================================

" Use :Silent command like normal but with redraw
command! -nargs=1 Silent
      \ | execute ':silent !'.<q-args>
      \ | execute ':redraw!'

augroup auglobal
  " Wrap lines in QuickFix buffer so that characters will not get lost
  autocmd bufenter * if &buftype == 'quickfix' | setlocal wrap | endif
  autocmd BufWinEnter * if &buftype == 'quickfix' | setlocal wrap | endif

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost * if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

  " Automatically open quickfix window after grepping
  autocmd QuickFixCmdPost *grep* cwindow

  " Close vim if the only window open is NERDTree
  autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

  " Enable spellchecking for Markdown
  autocmd FileType markdown setlocal spell

  " Initialize Airline sections
  if exists('airline')
    autocmd VimEnter * call AirlineInit()
  end
augroup END

"===============================================================================
" Plugin Settings
"===============================================================================

" NERDTree
let NERDTreeShowBookmarks = 1
let NERDTreeShowHidden = 1
let NERDTreeIgnore = ['\~$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']

" Syntastic
let g:syntastic_check_on_open = 1
let g:syntastic_cpp_check_header = 1
let g:syntastic_html_tidy_quiet_messages = { "level" : "warnings" }

" EasyMotion
map <Leader> <Plug>(easymotion-prefix)
let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyz'
hi link EasyMotionShade  Comment

" Airline
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

function! AirlineInit()
  let g:airline_section_b = airline#section#create_left(['%t'])
  let g:airline_section_c = airline#section#create([''])
  let g:airline_section_x = airline#section#create_right([''])
  let g:airline_section_y = airline#section#create_right(['%c'])
  let g:airline_section_z = airline#section#create_right(['branch'])
endfunction

let g:airline_theme_patch_func = 'AirLineTheme'
function! AirLineTheme(palette)
  if g:airline_theme == 'Tomorrow-Night'

    let green = ['', '', 255, 64, '']
    let magenta = ['', '', 255, 125, '']
    let orange = ['', '', 255, 166, '']

    let modes = {
      \ 'insert': green,
      \ 'replace': magenta,
      \ 'visual': orange
      \}

    for key in keys(modes)
      let a:palette[key].airline_a = modes[key]
      let a:palette[key].airline_z = modes[key]
    endfor
  endif
endfunction

let g:airline_mode_map = {
  \ '__' : '-',
  \ 'n'  : 'N',
  \ 'i'  : 'I',
  \ 'R'  : 'R',
  \ 'c'  : 'C',
  \ 'v'  : 'V',
  \ 'V'  : 'V-L',
  \ '' : 'V-B',
  \ 's'  : 'S',
  \ 'S'  : 'S',
  \ '' : 'S',
  \ }

" CtrlP
let g:ctrlp_map = '<C-p>'
let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup -g "" -p ~/'
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
let g:ctrlp_use_caching = 0

