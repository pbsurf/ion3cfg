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
" cterm colors here are based on rxvt defaults
hi Normal	guifg=Black  guibg=grey95
hi Comment	gui=NONE  guifg=SeaGreen  guibg=NONE ctermfg=2
hi Constant	gui=NONE  guifg=#004488  guibg=NONE
"hi Identifier	gui=NONE  guifg=Blue  guibg=NONE
hi String gui=NONE  cterm=NONE  ctermfg=5
hi Function	gui=NONE  cterm=NONE 
hi Statement 	gui=NONE  guifg=Blue  guibg=NONE  ctermfg=6
hi PreProc	gui=NONE  guifg=Blue  guibg=NONE  ctermfg=3
hi Type		gui=NONE  guifg=Blue  guibg=NONE  ctermfg=6
hi Special	gui=NONE  guifg=SteelBlue  guibg=NONE  ctermfg=6
"selection text
hi Visual gui=NONE guifg=White guibg=DarkBlue
"hi Underlined	
"hi Ignore		
"hi Error		
"hi Todo		


