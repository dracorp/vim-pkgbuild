" Vim plugin file
" Maintainer:   dracorp <piotr.r.public at gmail.com>
" URL:          https://github.com/dracorp/vim-pkgbuild

" Init Load Once:
if exists("g:loaded_pkgbuild") || &cp
    finish
endif
let g:loaded_pkgbuild = '0.2'
let s:keepcpo         = &cpo
set cpo&vim

 autocmd BufNewFile,BufRead PKGBUILD,*.PKGBUILD
    \ set filetype=PKGBUILD syntax=sh

"  Restore: {{{1
let &cpo= s:keepcpo
unlet s:keepcpo
" vim: ft=vim
