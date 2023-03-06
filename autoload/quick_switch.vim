function! quick_switch#Switch()
    let full_file_name = expand('%:t')

    if full_file_name == ''
        echoerr "Empty file name"
        return
    endif

    let l:filename = full_file_name[0:stridx(full_file_name, '.') - 1]
    let l:extension = full_file_name[stridx(full_file_name, '.'):]

    let l:find_result = systemlist('find . ' . ' -type f -name "' . l:filename . '*"')
    let l:match_files = []

    for l:group in g:quick_switch_patterns
        if index(l:group, l:extension) >= 0
            for l:ext in l:group
                if l:ext == l:extension
                    continue
                endif
                let l:idx = match(l:find_result, l:filename . l:ext . '$')
                if l:idx != -1
                    call add(l:match_files, l:find_result[l:idx])
                endif
            endfor
        endif
    endfor

    if l:match_files == []
        echo "No match found"
    elseif len(l:match_files) == 1
        execute ":e " . l:match_files[0]
    else
        let l:tmp_file = tempname()
        call system('echo -ne ' . join(l:match_files, '\\n') . ' > ' . l:tmp_file )
        " call system('echo -ne ' . join(l:match_files, '\\n') . ' > tmp.txt')
        " return

        " save defaults values
        let old_local_errorformat = &l:errorformat
        let old_errorformat = &errorformat

        " call setqflist(0, ['hi', 'mom'], ' ', {'title': 'Your title goes here'})
        call setqflist([], 'r', {'title' : 'Vim-QuickSwitch-QuickFix', 'items': [{'filename': 'a'}]})
        echo getqflist({'lines' : systemlist('grep -Hn quickfix *')})
        " call setqflist([{'filename': 'Vim-QuickFix'}, {'ln': 2}], 'r')
        " set errorformat=%f
        " exe 'cgetfile' . l:tmp_file
        copen
        call delete(l:tmp_file)

        " restore defaults values
        let &errorformat = old_errorformat
        let &l:errorformat = old_local_errorformat

    endif
endfunction
