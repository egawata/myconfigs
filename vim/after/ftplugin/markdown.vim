setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal expandtab

function! s:addIndentByTab()
  let l = getline(".")
  if match(l, "^ \*-$") > -1
    call setline(".", "    " . l . " ")
  else
    call setline(".", l . "    ")
  endif
  startinsert!
endfunction

function! s:removeIndentByTab()
  let l = getline(".")
  call setline(".", substitute(l, "^    ", "", ""))
  if match(l, "^ \*-$") > -1
    call setline(".", getline(".") . " ")
  endif
  startinsert!
endfunction

autocmd FileType markdown inoremap <silent> <Tab> <Esc>:call <SID>addIndentByTab()<CR>
autocmd FileType markdown inoremap <silent> <S-Tab> <Esc>:call <SID>removeIndentByTab()<CR>
