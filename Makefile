PLUGIN = vim-pkgbuild
DEST = ${HOME}/.vim

SOURCE = after/syntax/sh.vim
SOURCE += doc/pkgbuild.txt
SOURCE += plugin/pkgbuild.vim

all: ${PLUGIN}.vmb

${PLUGIN}.vmb: ${SOURCE}
	vim --cmd 'let g:plugin_name="${PLUGIN}"' -S build.vim

install:
	vim -c 'UseVimball ${DEST}' -c 'q'  ${PLUGIN}.vmb

clean:
	rm ${PLUGIN}.vmb

doc: tags

tags: doc/pkgbuild.txt
	vim -c 'helptags doc' -c 'q'

