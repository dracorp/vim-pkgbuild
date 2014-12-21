" Vim plugin file
" Language:     PKGBUILD
" Maintainer:   dracorp <piotr.r.public at gmail.com>
" URL:          https://github.com/dracorp/vim-pkgbuild

" Init:
if exists("g:pkgbuild_loaded") || &cp
    finish
endif
let g:pkgbuild_loaded='0.2'

augroup PkgbuildFile
    au!
    au BufNewFile,BufRead PKGBUILD,*.PKGBUILD set filetype=PKGBUILD syntax=sh
augroup end
