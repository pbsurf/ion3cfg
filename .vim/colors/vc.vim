" Vim color file
" Maintainer:   Vladimir Vrzic <random@bsd.org.yu>
" Last Change:  28. june 2003.
" URL:          http://galeb.etf.bg.ac.yu/~random/pub/vim/

set background=light
hi clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="vc"

" for a 8/16 color terminal, specifying cterm colors by name
"  instead of number automatically turns on bold
" cterm colors here are based on rxvt defaults:
" 1 dark red, 2 dark yellow/brown, 3 dark yellow/brown, 4 very dark blue, 5 dark purple, 6 dark cyan, 7 gray
" 8 dark gray, 9 red, 10 light green, 11 yellow, 12 dark blue, 13 magenta, 14 light cyan, 15 white
hi Normal       guifg=Black  guibg=grey95
hi Comment      gui=NONE  guifg=SeaGreen  guibg=NONE ctermfg=10
hi Constant     gui=NONE  guifg=#004488  guibg=NONE ctermfg=7
"hi Identifier  gui=NONE  guifg=Blue  guibg=NONE
hi String gui=NONE  cterm=NONE  ctermfg=13
hi Function     gui=NONE  cterm=NONE
hi Statement    gui=NONE  guifg=Blue  guibg=NONE  ctermfg=14
hi PreProc      gui=NONE  guifg=Blue  guibg=NONE  ctermfg=11
hi Type         gui=NONE  guifg=Blue  guibg=NONE  ctermfg=14
hi Special      gui=NONE  guifg=SteelBlue  guibg=NONE  ctermfg=14
"selection text
hi Visual gui=NONE guifg=White guibg=DarkBlue
"hi Underlined
"hi Ignore
"hi Error
"hi Todo
