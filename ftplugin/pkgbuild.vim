setlocal ts=2 sw=2 et tw=100
setlocal expandtab
setlocal foldmethod=expr
setlocal foldcolumn=4
setlocal foldexpr=pkgbuild#PkgbuildExpr(v:lnum)

function! s:MakeAur() "{{{
   execute "!mkaurball "
endfunction "}}}
function! s:MakePkg() "{{{
    execute "!makepkg -m"
endfunction "}}}
function! s:UpdPkgSums() "{{{
    execute "!updpkgsums"
endfunction "}}}
function! pkgbuild#PkgbuildExpr(lnum) "{{{
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

command! -nargs=* MakePkg call <SID>MakePkg()
command! -nargs=* MakeAur call <SID>MakeAur()
command! -nargs=0 UpdPkgSums call <SID>UpdPkgSums()
