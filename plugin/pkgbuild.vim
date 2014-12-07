" Plugin for PKGBUILDs
" Author: Piotr Rogoża
" Version: 0.1

if exists("g:dracorp_PKGBUILD")
    finish
endif

augroup PkgbuildFile
    au!
    au BufNewFile,BufRead PKGBUILD,*.PKGBUILD set filetype=pkgbuild syntax=sh
augroup end

