if exists("b:did_PKGBUILD_ftplugin")
  finish
endif
let b:did_PKGBUILD_ftplugin = 1

let s:clean_package='yes'
setlocal ts=2 sw=2 et tw=100
setlocal expandtab
setlocal foldmethod=expr
setlocal foldcolumn=4
setlocal foldexpr=PKGBUILD#PkgbuildExpr(v:lnum)

function! PKGBUILD#PkgbuildExpr(lnum) "{{{2
    let line = getline(a:lnum)

    if a:lnum == 1
        return 0
    endif

    if line =~ '^\s*\(package\|check\|build\|prepare\|pkgver\)\s*(\s*)\s*{\?'
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
endfunction
if executable('mkaurball') "{{{2
    function! s:MakeAur(...)
        let l:args = join(a:000)
        execute "!mkaurball -m " . l:args
    endfunction
    command! -nargs=? MakeAur call <SID>MakeAur(<q-args>)
    command! -nargs=? MakeSrc call <SID>MakeAur(<q-args>)
endif
if executable('makepkg') "{{{2
    function! s:MakePkg(...)
        let l:args = join(a:000)
        execute "!makepkg -m " . l:args
    endfunction
    command! -nargs=0 Install call <SID>MakePkg('-i')
    command! -nargs=* MakePkg call <SID>MakePkg(<q-args>)
endif
if executable('burp') "{{{2
    function! s:Burp(file)
        if filereadable(a:file)
            if a:file =~ 'src\.tar\.gz$'
                execute "!burp " . a:file
            endif
        endif
    endfunction
    command! -nargs=1 -complete=file Burp call <SID>Burp(<q-args>)
endif
if executable('namcap') "{{{2
    function! s:Namcap(file)
        if filereadable(a:file)
            if a:file =~ 'pkg\.tar\.xz$'
                execute "!namcap " . a:file
            endif
        endif
    endfunction
    command! -nargs=1 -complete=file Namcap call <SID>Namcap(<q-args>)
endif
if executable('updpkgsums') "{{{2
    command! -nargs=0 UpdPkgSums call ArchLinux#PKGBUILD#UpdPkgSums()
endif
" Menu Support: {{{2
if has("gui_running") && has("menu") && &go =~ 'm'
    if !exists("g:ArchTopLvlMenu")
        let g:ArchTopLvlMenu= "&ArchLinux.&PKGBUILD."
    endif
"    let g:ArchTopLvlMenu+='&PKGBUILD.'
    exe 'amenu '.g:ArchTopLvlMenu.'&updpkgsum<tab>:UpdPkgSums       :UpdPkgSums<cr>'
    exe 'an    '.g:ArchTopLvlMenu.'-sep1-                           <Nop>'
    exe 'amenu '.g:ArchTopLvlMenu.'&makepkg<tab>:MakePkg            :MakePkg<cr>'
    exe 'amenu '.g:ArchTopLvlMenu.'&makepkg\ -f<tab>:MakePkg        :MakePkg<cr>'
    exe 'an    '.g:ArchTopLvlMenu.'-sep2-                           <Nop>'
    exe 'amenu '.g:ArchTopLvlMenu.'makepkg\ -&i<tab>:Install         :Install<cr>'
    exe 'an    '.g:ArchTopLvlMenu.'-sep3-                           <Nop>'
    exe 'amenu '.g:ArchTopLvlMenu.'mk&aurball<tab>:MakeAur          :MakeAur<cr>'
    exe 'amenu '.g:ArchTopLvlMenu.'mk&aurball\ -f<tab>:MakeAur\ -f  :MakeAur -f<cr>'
    exe 'an    '.g:ArchTopLvlMenu.'-sep4-                           <Nop>'
    exe 'amenu '.g:ArchTopLvlMenu.'&burp<tab>:Burp                  :Burp '
    exe 'amenu '.g:ArchTopLvlMenu.'&namcap<tab>:Namcap              :Namcap '
"    let g:ArchTopLvlMenu-='&PKGBUILD.'
    exe 'an    '.g:ArchTopLvlMenu.'-sep5-                           <Nop>'
    exe 'amenu '.g:ArchTopLvlMenu.'Help                             :he PKGBUILD<CR>'
endif
" Mapping: {{{2
map <c-u> :UpdPkgSums<CR>
map <c-b> :MakePkg<CR>
map <c-i> :Install<CR>
map <c-n> :Namcap<CR>

" vim: ft=vim
