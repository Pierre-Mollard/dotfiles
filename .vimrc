set number
set relativenumber

set tabstop=4
set expandtab

set shiftround
set shiftwidth=4
set autoindent
set tabstop=4

" Number of line below or above cursor at minimum
set scrolloff=5
set sidescrolloff=5

set mouse=a
colorscheme delek

syntax on
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
hi Search ctermfg=Black

set history=1000

set wildmenu
set wildmode=list:longest
set wildignore=*.docx,*.xlsx

" Set current file as the pwd when edit or tabedit
set autochdir

" Show current command
set showcmd

" Directory to save cache files and backups
set dir=~/.cache/vim
set backupdir=~/.cache/vim

" Omni completion
filetype plugin on
set omnifunc=syntaxcomplete#Complete
