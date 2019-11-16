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
set backspace=indent,eol,start
set wildignorecase
filetype plugin on

set ttyfast
set lazyredraw

set splitbelow
set splitright

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
au BufNewFile,BufRead *.tsx set filetype=typescript

hi DiffAdd    ctermfg=black ctermbg=2
hi DiffChange ctermfg=black ctermbg=3
hi DiffDelete ctermfg=black ctermbg=6
hi DiffText   ctermfg=black ctermbg=7
hi Search     ctermfg=blue  ctermbg=yellow

set listchars=tab:>-
set list

inoremap <C-b> <Left>
inoremap <C-f> <Right>

noremap <F9> <esc>:tabnew<CR>
noremap <F10> <esc>:tabprev<CR>
noremap <F11> <esc>:tabnext<CR>
" タグジャンプ時に別tabを開く
nnoremap <F3> :<C-u>tab stj <C-R>=expand('<cword>')<CR><CR>

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
autocmd FileType go nmap <F8> :GoRun %<CR>


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
    call setline(line("$"), '1;')
    call cursor(6, 0)
    " echomsg path
endfunction
autocmd BufNewFile *.pm call s:pm_template()


let g:ackprg = 'ag --nogroup --nocolor --column'

" 通常の Plugin を読み込むときは s:vimrc_plugin_on = s:true にする
" s:false にすると、通常Pluginは読み込まれず、開発中のPluginのみが読み込まれる
" Plugin開発中は、Pluginのrootに .development.vim というファイルを設置する
let s:true = 1
let s:false = 0
let s:vimrc_plugin_on = get(g:, 'vimrc_plugin_on', s:true)
if len(findfile("./.development.vim", ".;")) > 0
  let s:vimrc_plugin_on = s:false
  set runtimepath&
  execute 'set runtimepath+=' . getcwd()
  for plug in split(glob(getcwd() . '/*'), '\n')
    execute 'set runtimepath+=' . plug
  endfor
endif

"
"  dein.vim
"
if s:vimrc_plugin_on == s:true
  if &compatible
    set nocompatible               " Be iMproved
  endif

  let s:deinroot = $HOME . "/.vim/dein"

  " Required:
  execute("set runtimepath+=" . s:deinroot . "/repos/github.com/Shougo/dein.vim")

  " Required:
  if dein#load_state(s:deinroot)
    call dein#begin(s:deinroot)

    " Let dein manage dein
    " Required:
    call dein#add(s:deinroot . '/repos/github.com/Shougo/dein.vim')

    call dein#add('Shougo/dein.vim')
    call dein#add('Shougo/neocomplete.vim')
    call dein#add('fatih/vim-go')
    call dein#add('ctrlpvim/ctrlp.vim')
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
    call dein#add('tpope/vim-fugitive')

    call dein#add('simeji/winresizer')

    call dein#add('Shougo/unite.vim')
    call dein#add('vim-perl/vim-perl')
    call dein#add('kshenoy/vim-signature')
    call dein#add('iamcco/markdown-preview.nvim', {'on_ft': ['markdown', 'pandoc.markdown', 'rmd'],
            \ 'build': 'cd app & yarn install' })
    call dein#add('banaoh/changed.vim')
    call dein#add('AndrewRadev/linediff.vim') " 2箇所のテキストの差分を表示

    "  deoplete
    call dein#add('Shougo/deoplete.nvim')
    if !has('nvim')
      call dein#add('roxma/nvim-yarp')
      call dein#add('roxma/vim-hug-neovim-rpc')
    endif
    let g:deoplete#enable_at_startup = 1
    let g:go_def_mapping_enabled = 0
    let g:go_doc_keywordprg_enabled = 0

    let s:toml_dir = expand("~/.config/nvim")
    call dein#load_toml(s:toml_dir . '/dein.toml', {'lazy': 0})
    call dein#load_toml(s:toml_dir . '/dein_lazy.toml', {'lazy': 1})

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
endif

"
"  end of dein.vim
"

"  Colorscheme
set t_Co=256
autocmd ColorScheme * highlight VisualNOS ctermfg=224 ctermbg=61
autocmd ColorScheme * highlight Visual ctermfg=224 ctermbg=61
highlight Normal ctermbg=none
if s:vimrc_plugin_on == s:true
  colorscheme molokai
endif

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
let g:vim_markdown_new_list_item_indent = 4

" indent-guides
"let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
let g:indent_guides_start_lebel = 2
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=237 ctermfg=59
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven  ctermbg=236 ctermfg=59

"  Nerd tree
command! Nt NERDTreeToggle

"  remove trailing whitespace
" autocmd BufWritePre * :%s/\s\+$//ge

command! OpenModuleUnderCursor call s:OpenModuleUnderCursor()
function! s:OpenModuleUnderCursor()
    silent normal "zyiw
    let l:moduleName = @z
    let l:filePath = 'lib/' . substitute(l:moduleName, '::', '/', 'g') . '.pm'
    if !filereadable(l:filePath)
        let l:modulePath = substitute(system('carton exec perldoc -l '. l:moduleName), "\n", "", "")
        if filereadable(l:modulePath)
            let l:filePath = l:modulePath
        endif
    endif
    exe 'tabe ' . l:filePath
endfunction
autocmd FileType perl nmap <F7> :OpenModuleUnderCursor<CR>

nnoremap <silent> <Space><Space> "zyiw:let @/ = '\<' . @z . '\>'<CR>:set hlsearch<CR>

" Highlight and replace under cursor
nmap # <Space><Space>:%s/<C-r>///g<Left><Left>

" grep under cursor (opening new tab)
noremap <Space>g "zyiw:tabnew<CR>:vimgrep /<C-r>z/ **/* \| cwin<CR>
noremap <Space>G "zyiw:tabnew<CR>:e ggrep_dummy<CR>:Ggrep <C-r>z \| cwin<CR>

nnoremap x "_x
nnoremap s "_s
" winresizer
let g:winresizer_vert_resize = 1
let g:winresizer_horiz_resize = 1
let g:winresizer_start_key = '<C-s>'

augroup HighlightTrailingSpaces
  autocmd!
  autocmd VimEnter,WinEnter,ColorScheme * highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
  autocmd VimEnter,WinEnter * match TrailingSpaces /\s\+$/
augroup END

inoremap { {}<Left>
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap ( ()<ESC>i
inoremap (<Enter> ()<Left><CR><ESC><S-o>
"inoremap ' ''<LEFT>
"inoremap " ""<LEFT>

"  grep 後に quickfix を開く
augroup qf_win
  autocmd!
  autocmd QuickfixCmdPost [^l]* copen
  autocmd QuickfixCmdPost l* lopen
augroup END

" for ctrlp.vim
set runtimepath^=~/.vim/bundle/ctrlp.vim

command! Drecache call dein#recache_runtimepath()
set clipboard=unnamed

" lightline config
let g:lightline = {
    \ 'colorscheme': 'wombat',
    \ 'component_function': {
    \   'filename': 'LightlineFilename',
    \ }
    \ }

function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction

" git ブランチ分岐元との diff
function! s:gdiffm()
    let orig = getcwd()
    lcd %:h
    let commit = system('git show-branch --merge-base master HEAD')
    echomsg "commit = " . commit
    exec "Gdiffsplit " . commit
    execute "lcd " . orig
endfunction

command! Gdiffm call s:gdiffm()

" Markdown indent
function! s:addIndentByTab()
  let l = getline(".")
  if match(l, '^\(    \)*-$') > -1
    call setline(".", '    ' . l . ' ')
    startinsert!
  elseif match(l, '^\(    \)*- $') > -1
    call setline(".", '    ' . l)
    startinsert!
  else
    execute('normal a    ')
    let curr = getcurpos()
    call cursor(curr[1], curr[2] + 1)
    startinsert
  endif
endfunction

function! s:removeIndentByTab()
  let l = getline(".")
  call setline(".", substitute(l, '^    ', '', ''))
  if match(l, '^\(    \)*-$') > -1
    call setline(".", getline(".") . ' ')
  endif
  startinsert!
endfunction

autocmd BufNewFile,BufRead *.md inoremap <silent> <Tab> <Esc>:call <SID>addIndentByTab()<CR>
autocmd BufNewFile,BufRead *.md inoremap <silent> <S-Tab> <Esc>:call <SID>removeIndentByTab()<CR>

" Shift-R で、選択範囲のコマンドを実行して別ウィンドウで出力結果を表示する
function! s:showShellCmdResultWithNewWin()
    let comm = trim(@*)
    exec 'new'
    call append(0, '> ' . comm)
    call append(1, '')
    call append(2, '~~~')
    normal! dd
    exec ":r!" . comm
    call append(line('$'), '~~~')
    call cursor(1, 1)
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
endfunction
vnoremap <S-R> y:silent call <SID>showShellCmdResultWithNewWin()<CR>
