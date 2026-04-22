set number
set relativenumber

set tabstop=4
set expandtab

set shiftround
set shiftwidth=4
set autoindent

" Number of line below or above cursor at minimum
set scrolloff=5
set sidescrolloff=5

syntax on
set mouse=a
set termguicolors      " Add this for truecolor if terminal supports
" colorscheme habamax      " Reliable dark builtin
colorscheme catppuccin_frappe      " Reliable dark builtin
hi Normal ctermbg=NONE  " Transparent fallback
hi Search ctermfg=Black

" Force transparency (GUI/TrueColor)
highlight Normal guibg=NONE ctermbg=NONE
highlight NonText guibg=NONE ctermbg=NONE
highlight NormalNC guibg=NONE ctermbg=NONE
highlight LineNr guibg=NONE ctermbg=NONE
highlight Folded guibg=NONE ctermbg=NONE
highlight EndOfBuffer guibg=NONE ctermbg=NONE
highlight SignColumn guibg=NONE ctermbg=NONE  " Added: Git gutter/signs column transparency

" Custom Colors
hi Search ctermfg=Black

set cursorline
set showmode
set showmatch

" Set the recommanded width of the file (0=edge of window)
" Line break: breaks by word rather than character
set textwidth=0
set wrapmargin=0
set wrap
set linebreak

" Always display the status bar (bottom)
set laststatus=1

" Incremental search
set ignorecase
set smartcase
set incsearch

set history=1000

set wildmenu
set wildmode=list:longest
set wildignore=*.docx,*.xlsx

" Set current file as the pwd when edit or tabedit
set autochdir

" Show current command
set showcmd

" Directory to save cache files and backups
set dir=~/.cache/vim backupdir=~/.cache/vim
silent! call mkdir(&dir, 'p', 0700)

" Omni completion
filetype plugin indent on
set omnifunc=syntaxcomplete#Complete
autocmd FileType c,cpp setlocal omnifunc=ccomplete#Complete
let mapleader = ' '

