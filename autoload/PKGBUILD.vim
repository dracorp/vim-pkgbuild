function! PKGBUILD#UpdPkgSums() "{{{
    execute "!updpkgsums"
endfunction "}}}
command! -nargs=0 UpdPkgSums call PKGBUILD#UpdPkgSums()
