" _vimrc
" 
"
" Creator:              Andrew Burnheimer
" Version:              1.2
" Date Created:         30 Mar 2005 11:48:34
" Date Modified:        26 Feb 2007 11:12:04

"set runtimepath=~/vimfiles,$VIMRUNTIME

"Potwiki tweaks
let potwiki_home = 'C:/Documents and Settings/aburnh000/My Documents/School/HomePage'

"1337 GUI options
set go=acgm
set gfn=Monospace\ 8	" for Unix
"set gfn=Terminal:h8:w4	" for Windows

"Set -reverse when you can't (Windows)
colorscheme torte  

"More often the case
set bg=dark
set hlsearch
set nowrap
set number

"Makes those irritating files~...
set nobackup

"In case there's any ambiguity
syntax enable

map insdate a<C-R>=strftime("%c")<CR><Esc> " When you can get away with it
"map <F2> a<C-R>=strftime("%d %b %Y %H:%M:%S")<CR><Esc> " When you can't

"Multi-window tweaks
map <C-h> <C-w><C-h>
map <C-k> <C-w><C-k>
map <C-j> <C-w><C-j>
map <C-l> <C-w><C-l>

" Yank the current line into buffer y and execute it
map - "yyy:@y^M

" "	Use buffer
" y	buffer y
" yy	yank current line
" :	switch to command line
" @y^M	put contents of buffer y onto command line

" For use with Vim7.0
"setlocal spell spelllang=en_us
set nospell

" Better case handling in searches (insensitivity)
set ignorecase
set smartcase

"MBE tweaks
map <PageUp> :MBEbp<CR>
map <PageDown> :MBEbn<CR>
map <Delete> :bdelete 
map <Home> :TMiniBufExplorer<CR> 

"Vim JDE completion tweaks
map <F6> <C-x><C-u>
map <F7> <C-p>
map <F8> <C-n>

let g:js_indent_log = 0

let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBuffs = 1
let g:miniBufExplModSelTarget = 1

filetype plugin on

function! Hex2Dec()
    let lstr = getline(".")
    let hexstr = matchstr(lstr, '0x[a-fA-F0-9]\+')
    while hexstr != ""
        let hexstr = hexstr + 0
        exe 's#0x[a-fA-F0-9]\+#'.hexstr."#"
        let lstr = substitute(lstr, '0x[a-fA-F0-9]\+', hexstr, "")
        let hexstr = matchstr(lstr, '0x[a-fA-F0-9]\+')
    endwhile
endfunction

function! Dec2Hex()
    let lstr = getline(".")
    let decstr = matchstr(lstr, '\<[0-9]\+\>')
    while decstr != ""
        let decstr = printf("0x%x", decstr)
        exe 's#\<[0-9]\+\>#'.decstr."#"
    	let lstr = getline(".")
        let decstr = matchstr(lstr, '\<[0-9]\+\>')
    endwhile
endfunction

