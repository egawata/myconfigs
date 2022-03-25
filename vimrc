set encoding=utf-8
scriptencoding utf-8
set incsearch
set smarttab

" tabstop: 何文字のスペースをタブ文字とみなすか
" softtabstop: tab キーを押したときにいくつのスペースを入れるか
" shiftwidth: 自動インデント時にどれだけ文字をずらすか(<<, >> など)
set expandtab
set tabstop=4
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
set wrap
filetype plugin on

set ttyfast
set lazyredraw

" split, vsplit 時に新しいウィンドウを現在のウィンドウの下 or 右側に作る
set splitbelow
set splitright

" ハイライトグループ `Normal` の設定
" 背景色は設定無し(none)にする
highlight Normal ctermbg=none

let mapleader = ','

" autocommand group を定義し、そのグループ限定の設定を記述する。
" augroup END までの間がグループ限定の設定
" グループ名は、スペース以外の文字は何でも使える
" - autocmd とは？
"   - 特定の操作を行ったときに自動的に実行されるコマンドを定義するためのもの
"     - ファイルの読み書き
"     - buffer, window に入った、もしくは離れたとき
"     - vim を終了したとき
" - augroup はなぜ必要？
"   - .vimrc を再読み込みすると、設定が二重に行われるのを避けるため
"     - 二重に設定されると遅くなる
"   - 一旦 autocmd! で全消去しているので、前の同じ設定が消されてから定義される
augroup vimrc-auto-cursorline
    " autocmd を一旦全消去する
    autocmd!
    " autocmd [GROUP] event file-pattern cmd
    " cursorline は、現在カーソルのある行をハイライトする
    " CursorMoved は、カーソルが移動したとき(I はインサートモードのとき)
    " CursorHold は、キーが押されないまま一定時間が過ぎたとき
    " WinLeave は、ウィンドウを離れるとき
    autocmd CursorMoved,CursorMovedI,WinLeave * setlocal nocursorline
    autocmd CursorHold,CursorHoldI * setlocal cursorline
augroup END

" TODO: 目的不明。消しても問題ないか検証
autocmd FileType perl inoremap # X#
autocmd FileType perl setlocal iskeyword=@,48-57,_,192-255,:

iab pmod <esc>:r ~/.code_templates/perl_module.pl<return><esc>
iab papp <esc>:r ~/.code_templates/perl_application.pl<return><esc>
iab test_mysqld <esc>:r ~/.code_templates/test_mysqld.pl<return><esc>
iab vue_tmpl <esc>:r ~/.code_templates/vue_template.html<return><esc>ggdd17G

augroup special-filetype
  autocmd!
  au BufNewFile,BufRead *.t set filetype=perl
  au BufNewFile,BufRead *.psgi set filetype=perl
  au BufNewFile,BufRead *.tt set filetype=html
  au BufNewFile,BufRead *.tsx set filetype=typescript
augroup END

" highlight は、ハイライトグループごとの色を指定する
" DiffXXX は、diff モードで使用されるもの
" Search は、最後に検索された文字列
highlight DiffAdd    ctermfg=black ctermbg=2
highlight DiffChange ctermfg=black ctermbg=3
highlight DiffDelete ctermfg=black ctermbg=6
highlight DiffText   ctermfg=black ctermbg=7
highlight Search     ctermfg=blue  ctermbg=yellow

" list モード
" - tab と行末を特別な表示方法にする
" - listchars=tab:xy で、タブ文字が xyyy のように表示される
" - listchars=eol:c で、行末に c と表示される
" set list で実際に list モードに移行している
set listchars=tab:>-
set list

set iskeyword+=-

inoremap <C-b> <Left>
inoremap <C-f> <Right>

noremap <F10> <esc>:tabprev<CR>
noremap <F11> <esc>:tabnext<CR>
" タグジャンプ時に別tabを開く
" tab {cmd} : cmd を実行する。もし cmd が新しいwindowを開くような動作であれば、代わりに tab を開く。
" ts[elect] {name}: name に合致するタグを検索して表示する
" tj[ump] {name} : tselect と同じだが、match するものが1つしかなければlistを表示せず直接jumpする
" stj[ump] {name} : tjump と同じ。split して新しい jump 先をそこに表示
" <cword> カーソル下にある文字列を表す
nnoremap <F3> :<C-u>tab stj <C-R>=expand('<cword>')<CR><CR>

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

augroup run-script
    autocmd!
    autocmd FileType perl nmap <F8> :Perl<CR>
    autocmd FileType python nmap <F8> :Python<CR>
augroup END

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
endfunction

augroup perl_pm_template
    autocmd!
    autocmd BufNewFile *.pm call s:pm_template()
augroup END

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

" vim-plug
"// PLUGIN SETTINGS
call plug#begin('~/.config/nvim/plugged')

    Plug 'tomasr/molokai'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'preservim/nerdtree'
    Plug 'itchyny/lightline.vim'

    Plug 'tyru/open-browser.vim'
    Plug 'tyru/open-browser-github.vim'
    nmap <Space>s <Plug>(openbrowser-smart-search)

    Plug 'egawata/sh-cmd-runner'
    let g:sh_cmd_runner_run_cmd_key = '<S-r>'
    let g:sh_cmd_runner_cmd_prefix = '$ '
    let g:sh_cmd_runner_result_separator = '~~~'

    Plug 'glidenote/memolist.vim'

    "# Esc 押下後自動的に英数モードに切り替え
    Plug 'brglng/vim-im-select'
    let g:im_select_default = 'com.google.inputmethod.Japanese.Roman'

    "# gctags
    "# f 今のファイルの関数などの一覧
    "# j カーソル下の単語が含まれるタグの表示
    "# d カーソル下の単語の参照元を表示
    "# c カーソル下の単語の参照先を表示
    Plug 'lighttiger2505/gtags.vim'
    nnoremap <silent> <Space>f :Gtags -f %<CR>
    nnoremap <silent> <Space>j :GtagsCursor<CR>
    nnoremap <silent> <Space>d :<C-u>exe('Gtags '.expand('<cword>'))<CR>
    nnoremap <silent> <Space>c :<C-u>exe('Gtags -r '.expand('<cword>'))<CR>

    " <leader>j でカーソル下単語の定義を探す
    Plug 'pechorin/any-jump.vim'

    " LineDiff
    Plug 'AndrewRadev/linediff.vim'

    " lsp
    Plug 'prabirshrestha/asyncomplete.vim'
    Plug 'prabirshrestha/asyncomplete-lsp.vim'
    Plug 'prabirshrestha/vim-lsp'
      let g:lsp_diagnostics_enabled = 0
      let g:lsp_log_verbose = 0
      " vim-lsp の定義ジャンプが利用できない場合は vim 本来のタグジャンプにフォールバックする
      nnoremap <expr> <silent> <C-]> execute(':LspDefinition') =~ "not supported" ? "\<C-]>" : ":echo<cr>"

    Plug 'mattn/vim-lsp-settings'
    let g:lsp_settings_servers_dir = "~/.local/share/vim-lsp-settings/servers"
    nnoremap <C-]> :LspDefinition<CR>
    nnoremap <C-w>] :sp<CR>:LspDefinition<CR>
    nnoremap <C-w><C-]> :sp<CR>:LspDefinition<CR>

    " go の最低限の設定
    Plug 'mattn/vim-goimports'

    Plug 'rcmdnk/vim-markdown'

    Plug 'APZelos/blamer.nvim'

    " nerdtree に grep(g)コマンドを追加する
    Plug 'MarSoft/nerdtree-grep-plugin'

    " window サイズを hjkl で変更(Ctrl-s)
    Plug 'simeji/winresizer'
    let g:winresizer_vert_resize = 1
    let g:winresizer_horiz_resize = 1
    let g:winresizer_start_key = '<C-s>'

call plug#end()

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
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

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

command! OpenPerldocUnderCursor call s:OpenPerldocUnderCursor()
function! s:OpenPerldocUnderCursor()
    silent normal "zyiw
    let l:moduleName = @z
    let l:filePath = 'lib/' . substitute(l:moduleName, '::', '/', 'g') . '.pm'
    exe 'new'
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    if filereadable(l:filePath)
      exe 'r!perldoc ' . l:filePath
    else
      exe 'r!carton exec perldoc ' . l:moduleName
    endif
    exe ':normal gg'
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

autocmd BufNewFile,BufRead *.md,*.markdown inoremap <silent> <Tab> <Esc>:call <SID>addIndentByTab()<CR>
autocmd BufNewFile,BufRead *.md,*markdown inoremap <silent> <S-Tab> <Esc>:call <SID>removeIndentByTab()<CR>

" perl で、カーソル下モジュールの perldoc を表示する
autocmd Filetype perl nnoremap <Space>p :OpenPerldocUnderCursor<CR>

if filereadable($HOME . '/.vimrc.include')
  exe 'source ' . $HOME . '/.vimrc.include'
endif

" カーソル下のファイルを開く
" gf, gF で新しいタブで開く。<C-w> をつけると同じタブで開く
" また gf と gF を逆にする
nnoremap gf  <c-w>gF
nnoremap gF  <c-w>gf
nnoremap <c-w>gf gF
nnoremap <c-w>gF gf

" 現在より右側のタブをすべて終了する
command! -nargs=0 Tabcr :.+1,$tabdo :q

" NeoSnippet
" Plugin key-mappings.
    " Note: It must be "imap" and "smap".  It uses <Plug> mappings.
    imap <C-k>     <Plug>(neosnippet_expand_or_jump)
    smap <C-k>     <Plug>(neosnippet_expand_or_jump)
    xmap <C-k>     <Plug>(neosnippet_expand_target)

    " SuperTab like snippets behavior.
    " Note: It must be "imap" and "smap".  It uses <Plug> mappings.
    "imap <expr><TAB>
    " \ pumvisible() ? "\<C-n>" :
    " \ neosnippet#expandable_or_jumpable() ?
    " \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
    smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
    \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

    " For conceal markers.
    if has('conceal')
      set conceallevel=2 concealcursor=niv
    endif
" NeoSnippet end

autocmd Syntax * call matchadd('Todo',  '\W\zs\(TODO\|FIXME\|CHANGED\|XXX\|BUG\|HACK\|RESOLVED:\|QUESTION:\)')

" ,b で :buffers コマンドを起動する
nnoremap <Leader>b :buffers<CR>

" json 等でダブルクォート等を非表示にするのをやめる
set conceallevel=0

" 2タブと4タブを切り替える
function! s:change_tab(width)
  execute("setlocal tabstop=" . a:width)
  execute("setlocal softtabstop=" . a:width)
  execute("setlocal shiftwidth=" . a:width)
endfunction

command! Tab4 call s:change_tab(4)
command! Tab2 call s:change_tab(2)

nnoremap Y yy
