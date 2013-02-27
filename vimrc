set ts=4
set sw=4
set softtabstop=4
set expandtab
set incsearch
set scrolloff=5
set showmatch
set statusline=%F%m%r%h\ %y%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%=%c:%l/%L
set laststatus=2
set smartindent
set nocindent
set comments=sl:/*,mb:*,elx:*/
set indentkeys={,0},:,!^F,o,O,e
set cinoptions=#1
set ambiwidth=double
set number
set hls
set ambiwidth=double

augroup vimrc-auto-cursorline
    autocmd!
    autocmd CursorMoved,CursorMovedI,WinLeave * setlocal nocursorline
    autocmd CursorHold,CursorHoldI * setlocal cursorline
augroup END

autocmd FileType perl inoremap # X#

iab pmod <esc>:r ~/.code_templates/perl_module.pl<return><esc>
iab papp <esc>:r ~/.code_templates/perl_application.pl<return><esc>

au BufNewFile,BufRead *.t set filetype=perl 

set listchars=tab:>-
set list
