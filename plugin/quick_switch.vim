if exists('g:quick_switch_loadded')
    finish
endif
let g:quick_switch_loadded = 1

let g:quick_switch_patterns = [
            \ ['.cpp', '.cc', '.c', '.cxx', '.h', '.hpp', '.hxx'],
            \ ['.js', '.ts', '.css'],
            \ ['.service.ts', '.controller.ts']
            \]

autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>:cclose<CR>

" augroup vimrc_colors
  " autocmd ColorScheme * hi QuickFixLine ctermfg=NONE cterm=bold guifg=NONE gui=bold
" augroup END
" au BufReadPost quickfix setlocal modifiable
"     \ | silent exe '%s/|| //'
"     \ | setlocal nomodifiable

command! QuickSwitch :call quick_switch#Switch()
