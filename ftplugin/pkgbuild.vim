setlocal ts=2 sw=2 et tw=100
setlocal expandtab
setlocal foldmethod=expr
setlocal foldcolumn=2
setlocal foldexpr=pkgbuild#PkgbuildExpr(v:lnum)

function! s:MakeAur(...) "{{{
   execute "!mkaurball " .  "a:000"
endfunction "}}}
function! s:MakePkg(...) "{{{
    execute "!makepkg -m" . "a:000"
endfunction "}}}
function! s:UpdPkgSums() "{{{
    execute "!updpkgsums"
endfunction "}}}
function! pkgbuild#PkgbuildExpr(lnum) "{{{
    let line = getline(a:lnum)

    if a:lnum == 1
        return 0
    endif

    if line =~ '^\s*\(package|check|build\)\s*(\s*)\s*{\?'
        " begin 1st level
        return '>1'
    elseif line =~ '[a-z_]\s*(\s*)\s*{'
        " begin 1st level another function
        return '>1'
    elseif line =~ '^}'
        " end 1st level
        return '<1'
    elseif line =~ '=\s*(\s*$'
        " begin of an array
        return '>2'
    elseif line =~ '^sha\d\+sums='
        " begin of array of *sums
        return '>2'
    elseif line =~ '^\s*)\s*$'
        " end of an array
        return '<2'
    else
        return '='
    endif
endfunction "}}}

command! -nargs=* MakePkg call <SID>MakePkg(<q-args>)
command! -nargs=* MakeAur call <SID>MakeAur(<q-args>)
command! -nargs=0 UpdPkgSums call <SID>UpdPkgSums()
