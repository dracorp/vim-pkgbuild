if executable('updpkgsums')
    function! ArchLinux#PKGBUILD#UpdPkgSums()
        execute "!updpkgsums"
    endfunction
endif
" vim: ft=vim
