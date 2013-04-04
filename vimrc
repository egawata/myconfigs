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
set nowrapscan

augroup vimrc-auto-cursorline
    autocmd!
    autocmd CursorMoved,CursorMovedI,WinLeave * setlocal nocursorline
    autocmd CursorHold,CursorHoldI * setlocal cursorline
augroup END

autocmd FileType perl inoremap # X#

iab pmod <esc>:r ~/.code_templates/perl_module.pl<return><esc>
iab papp <esc>:r ~/.code_templates/perl_application.pl<return><esc>

au BufNewFile,BufRead *.t set filetype=perl 

hi DiffAdd    ctermfg=black ctermbg=2
hi DiffChange ctermfg=black ctermbg=3
hi DiffDelete ctermfg=black ctermbg=6
hi DiffText   ctermfg=black ctermbg=7

set listchars=tab:>-
set list


"
"  Change status line color in insert mode
"
let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=black ctermbg=green cterm=none'

if has('syntax')
  augroup InsertHook
    autocmd!
    autocmd InsertEnter * call s:StatusLine('Enter')
    autocmd InsertLeave * call s:StatusLine('Leave')
  augroup END
endif

let s:slhlcm = ''
function! s:StatusLine(mode)
  if a:mode == 'Enter'
    silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
    silent exec g:hi_insert
  else
    highlight clear StatusLine
    silent exec s:slhlcmd
  endif
endfunction

function! s:GetHighlight(hi)
  redir => hl
  exec 'highlight '.a:hi
  redir END
  let hl = substitute(hl, '[\r\n]', '', 'g')
  let hl = substitute(hl, 'xxx', '', '')
  return hl
endfunction

