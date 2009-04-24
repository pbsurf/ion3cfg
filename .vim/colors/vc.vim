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

hi Normal	guifg=Black  guibg=grey95
hi Comment	gui=NONE  guifg=SeaGreen  guibg=NONE ctermfg=green
hi Constant	gui=NONE  guifg=#004488  guibg=NONE
"hi Identifier	gui=NONE  guifg=Blue  guibg=NONE
hi Statement 	gui=NONE  guifg=Blue  guibg=NONE  ctermfg=LightBlue
hi PreProc	gui=NONE  guifg=Blue  guibg=NONE  ctermfg=LightBlue	
hi Type		gui=NONE  guifg=Blue  guibg=NONE  ctermfg=LightBlue
hi Special	gui=NONE  guifg=SteelBlue  guibg=NONE  ctermfg=LightBlue
"selection text
hi Visual gui=NONE guifg=White guibg=DarkBlue
"hi Underlined	
"hi Ignore		
"hi Error		
"hi Todo		


