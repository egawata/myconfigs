set tabstop=4
set expandtab
set incsearch  
set smarttab
set softtabstop=4
set shiftwidth=4
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
set foldmethod=syntax
let perl_fold=1
set foldlevel=2
set foldnestmax=2
set ignorecase
set smartcase
filetype plugin on

set ttyfast
set lazyredraw

set splitbelow
set splitright

"  Colorscheme
set t_Co=256
autocmd ColorScheme * highlight VisualNOS ctermfg=224 ctermbg=61
autocmd ColorScheme * highlight Visual ctermfg=224 ctermbg=61
colorscheme molokai
highlight Normal ctermbg=none

augroup vimrc-auto-cursorline
    autocmd!
    autocmd CursorMoved,CursorMovedI,WinLeave * setlocal nocursorline
    autocmd CursorHold,CursorHoldI * setlocal cursorline
augroup END

autocmd FileType perl inoremap # X#

iab pmod <esc>:r ~/.code_templates/perl_module.pl<return><esc>
iab papp <esc>:r ~/.code_templates/perl_application.pl<return><esc>
iab test_mysqld <esc>:r ~/.code_templates/test_mysqld.pl<return><esc>

au BufNewFile,BufRead *.t set filetype=perl 
au BufNewFile,BufRead *.psgi set filetype=perl 
au BufNewFile,BufRead *.tt set filetype=html 

hi DiffAdd    ctermfg=black ctermbg=2
hi DiffChange ctermfg=black ctermbg=3
hi DiffDelete ctermfg=black ctermbg=6
hi DiffText   ctermfg=black ctermbg=7
hi Search     ctermfg=blue  ctermbg=yellow

set listchars=tab:>-
set list

inoremap <C-b> <Left>
inoremap <C-f> <Right>

map <F9> :tabnew<CR>
map <F10> :tabprev<CR>
map <F11> :tabnext<CR>

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


"  Run editing source
command! Perl call s:Perl()
function! s:Perl()
  :w
  :!perl % 
endfunction 

command! Python call s:Python()
function! s:Python()
  :w
  :!python3 % 
endfunction 

autocmd FileType perl nmap <F8> :Perl<CR>
autocmd FileType python nmap <F8> :Python<CR>


function! s:pm_template()
    let path = substitute(expand('%'), '.*lib/', '', 'g')
    let path = substitute(path, '[\\/]', '::', 'g')
    let path = substitute(path, '\.pm$', '', 'g')

    call append(0, 'package ' . path . ';')
    call append(1, 'use strict;')
    call append(2, 'use warnings;')
    call append(3, 'use utf8;')
    call append(4, '')
    call append(5, '')
    call append(6, '')
    call append(7, '1;')
    call cursor(6, 0)
    " echomsg path
endfunction
autocmd BufNewFile *.pm call s:pm_template()


let g:ackprg = 'ag --nogroup --nocolor --column'


"
"  dein.vim
"

if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/home/egawata/.vim/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('/home/egawata/.vim/dein')
  call dein#begin('/home/egawata/.vim/dein')

  " Let dein manage dein
  " Required:
  call dein#add('/home/egawata/.vim/dein/repos/github.com/Shougo/dein.vim')

  call dein#add('Shougo/dein.vim')
  call dein#add('Shougo/neocomplete.vim')
  call dein#add('fatih/vim-go')
  call dein#add('mileszs/ack.vim')
  call dein#add('jbgutierrez/vim-babel')
  call dein#add('kchmck/vim-coffee-script')
  call dein#add('leafgarland/typescript-vim')
  " ES6対応
  call dein#add('othree/yajs.vim')
  " ES7対応
  call dein#add('othree/es.next.syntax.vim')
  " JSX
  call dein#add('mxw/vim-jsx')

  call dein#add('mattn/webapi-vim')
  call dein#add('mattn/gist-vim')

  call dein#add('chase/vim-ansible-yaml')

  call dein#add('rcmdnk/vim-markdown')
  call dein#add('Shougo/unite.vim')
  call dein#add('tomasr/molokai')
  call dein#add('nathanaelkane/vim-indent-guides')
  call dein#add('scrooloose/nerdtree')
  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/neosnippet-snippets')
  call dein#add('tomtom/tcomment_vim')

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

if dein#check_install()
  call dein#install()
endif

"
"  end of dein.vim
"

"  .jsx 以外のファイルにもJSXを適用
let g:jsx_ext_required = 0

"  gist 設定
let g:gist_post_private = 1
"let g:gist_open_browser_after_post = 1

"  vim-ansible-yaml 
"  Ctrl-k でドキュメント検索
let g:ansible_options = {'documentation_mapping': '<C-K>'}

"  vim-markdown
let g:vim_markdown_folding_disabled = 1

" indent-guides
"let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
let g:indent_guides_start_lebel = 2
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=237
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven  ctermbg=236

"  Nerd tree
command Nt NERDTreeToggle

