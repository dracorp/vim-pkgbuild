let s:clean_package='yes'
setlocal ts=2 sw=2 et tw=100
setlocal expandtab
setlocal foldmethod=expr
setlocal foldcolumn=4
setlocal foldexpr=PKGBUILD#PkgbuildExpr(v:lnum)

function! PKGBUILD#PkgbuildExpr(lnum) "{{{
    let line = getline(a:lnum)

    if a:lnum == 1
        return 0
    endif

    if line =~ '^\s*\(package\|check\|build\|prepare\)\s*(\s*)\s*{\?'
        " begin 1st level
        return '>1'
    elseif line =~ '^\s*package_[[:alnum:]]\+'
        " package_subpackage
        return '>1'
    elseif line =~ '^[_]?[[:alnum:]]\+\s*(\s*)\s*{'
        " another additional function
        return '>1'
    elseif line =~ '^}'
        " end 1st level
        return '<1'
    elseif line =~ '=\s*(\s*$'
        " begin of an array
        return 'a1'
    elseif line =~ '^\s*)\s*$'
        " end of an array
        return 's1'
    elseif line =~ '\v(md|sha)\d+sums=.*[^)]$'
        return '>1'
    elseif line =~ '^\s*[''][[:alnum:]]\+[''])$'
        return '<1'
    else
        return '='
    endif
endfunction "}}}
if executable('mkaurball')
    function! s:MakeAur(...) "{{{
        let l:args = join(a:000)
        execute "!mkaurball " . l:args
    endfunction "}}}
    command! -nargs=? MakeAur call <SID>MakeAur(<q-args>)
    command! -nargs=? MakeSrc call <SID>MakeAur(<q-args>)
endif
if executable('makepkg')
    function! s:MakePkg(...) "{{{
        let l:args = join(a:000)
        execute "!makepkg  " . l:args
    endfunction "}}}
    command! -nargs=0 Install call <SID>MakePkg('-i')
    command! -nargs=* MakePkg call <SID>MakePkg(<q-args>)
endif
if executable('burp')
    function! s:Burp(file) "{{{
        if filereadable(a:file)
            if a:file =~ 'src\.tar\.gz$'
                execute "!burp " . a:file
            endif
        endif
    endfunction "}}}
    command! -nargs=1 -complete=file Burp call <SID>Burp(<q-args>)
endif
