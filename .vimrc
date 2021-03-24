"
" Based on vim no plugins talk: youtube.com/watch?v=XA2WjJbmmoM
"

"not vi
set nocompatible

"enable syntax and netrw
syntax enable
filetype plugin on

"search down into subfolders with find: tab
set path+=**
"display files with tab complete, fuzzy wildcards 
set wildmenu

"tag making, tag jumping ctrl+], g+ctrl+] for multple, ctrl+t to go back
command! MakeTags !ctags -R .

"basic autocomplete, ctrl+n 
"ctrl+x + ctrl+n just for things in this file
"ctrl+x + ctrl+f for files
"ctrl+x + ctrl+] for tags only

"file browsing, :edit folder
let g:netrw_banner=0
let g:netrw_browse_split=4
let g:netrw_altv=1
let g:netrw_liststyle=3
let g:netrw_list_hide=netrw_gitignore#Hide()

"set colorscheme 
autocmd vimenter * ++nested colorscheme gruvbox
set background=dark

call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
call plug#end()
