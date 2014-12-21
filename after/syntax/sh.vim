" Vim syntax file
" Language: sh
" Maintainer: dracorp
" Extends: sh.vim
" Last change: 05.12.2014

syn case ignore
syn keyword PkgMetaParam Maintainer Contributor

syn match PkgMetaValue      ':.*'ms=s+1 contained
syn match PkgComments       '#.*' contains=PkgMetaParam,PkgMetaValue

" highlight
command -nargs=+ HiLink hi def link <args>
HiLink PkgComments Comment

"highlight   PkgMetaParam       ctermfg=blue guifg=blue
HiLink  PkgMetaParam Keyword
HiLink  PkgMetaValue String
"highlight   PkgMetaValue       ctermfg=green guifg=green

delcommand HiLink
