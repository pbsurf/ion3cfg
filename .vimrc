" VIM config file

" no attempt at vi compatibility
set nocompatible
set gfn=Dina\ 8,Courier\ New\ 9
set guioptions+=b
set tabstop=2
set shiftwidth=2
set expandtab
colorscheme vc
" Switch syntax highlighting on
syntax on
" this may be necessary for 256 color terminal
"set t_Co=256
"I always accidently hit the insert key...
imap <Insert> <Delete>
"Don't want middle button paste
noremap <MiddleMouse> <LeftMouse>
noremap <2-MiddleMouse> <2-LeftMouse>
noremap <3-MiddleMouse> <3-LeftMouse>
noremap <4-MiddleMouse> <4-LeftMouse>
inoremap <MiddleMouse> <LeftMouse>
inoremap <2-MiddleMouse> <2-LeftMouse>
inoremap <3-MiddleMouse> <3-LeftMouse>
inoremap <4-MiddleMouse> <4-LeftMouse>
"Map tab key for block indenting with mswin behavior
vnoremap <Tab> ^0 >
vnoremap <S-Tab> ^0 <
"Spell check toggle: F5
map <silent> <F5> :setlocal invspell<CR>
inoremap <silent> <F5> <ESC> :setlocal invspell<CR>a

" Case insensitive search unless uppercase char typed
set ignorecase smartcase
" Incremental searching
set incsearch
" Switch on highlighting of the last used search pattern
set hlsearch
" set search highlight colors independent of syntax highlighting theme
hi Search cterm=NONE ctermfg=Black ctermbg=Yellow
" use F2 to toggle line numbering
nmap <f2> :set number! <CR>
" use F3 to toggle word wrap
set nowrap
nmap <f3> :set wrap! <CR>

" use F4 to toggle paste mode
nnoremap <F4> :set invpaste paste?<CR>
set pastetoggle=<F4>
set showmode

" From: $VIMRUNTIME/vimrc_example.vim - these may need to be revised

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" keep a backup file
set backup
set backupdir=$TEMP,$TMP,~/tmp,/tmp,$VIM,.
" location for swap files
set directory=$TEMP,$TMP,~/tmp,/tmp,$VIM,.

set history=50  " keep 50 lines of command line history
set ruler       " show the cursor position all the time
set showcmd     " display incomplete commands

" Don't use Ex mode, use Q for formatting
map Q gq

" always use the mouse
set mouse=a

" Copied directly from vimrc_example
" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " Override some format options from filetype plugins
  " autowrap and format comments; don't insert comment leaders on
  "  newline; see help fo-table for info
  au Filetype * set formatoptions+=c
  au Filetype * set formatoptions-=r

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END
else
  set autoindent  " always set autoindenting on
endif " has("autocmd")

" highlight trailing spaces - from http://vim.wikia.com/wiki/Highlight_unwanted_spaces
highlight ExtraWhitespace cterm=NONE ctermbg=Red
au BufWinEnter * let w:m1=matchadd('ExtraWhitespace', '\s\+$', -1)
au InsertEnter * call matchdelete(w:m1)
" this uses some crazy vim regex to reject whitespace behind the current cursor position
au InsertEnter * let w:m2=matchadd('ExtraWhitespace', '\s\+\%#\@<!$', -1)
au InsertLeave * call matchdelete(w:m2)
au InsertLeave * let w:m1=matchadd('ExtraWhitespace', '\s\+$', -1)

" remove trailing whitespace on save - disabled for now
"autocmd BufWritePre * :%s/\s\+$//e

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
    \ | wincmd p | diffthis
" End vimrc_example.vim

" Key mappings, settings, etc. for Windows behavior
source $VIMRUNTIME/mswin.vim
"behave mswin  -- Included in mswin.vim

" mswin.vim seems to map C-Z, C-Y correctly to undo/redo, but not the
" clipboard commands.  This lets me select text with the mouse and use C-C, C-X
vmap <C-c> y<Esc>i
vmap <C-x> d<Esc>i
" this lets me paste with C-V in insert mode
imap <C-v> <Esc>pa
" use system clipboard - doesn't seem to work right, but Shift-Ins works, so no problem
"set clipboard=unnamed

if has('win32')
  set diffexpr=MyDiff()
  function MyDiff()
    let opt = '-a --binary '
    if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
    if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
    let arg1 = v:fname_in
    if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
    let arg2 = v:fname_new
    if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
    let arg3 = v:fname_out
    if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
    let eq = ''
    if $VIMRUNTIME =~ ' '
      if &sh =~ '\<cmd'
        let cmd = '""' . $VIMRUNTIME . '\diff"'
        let eq = '"'
      else
        let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
      endif
    else
      let cmd = $VIMRUNTIME . '\diff'
    endif
    silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
  endfunction
endif

" Start in insert mode
":startinsert

