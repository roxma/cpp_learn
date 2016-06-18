#!/bin/bash

echo "function roxma_vim_rcfile(){"
vimrcEncodedContent="$(cat $(find ./ -maxdepth 1 -name vimrc -o -name "*.vimrc" -o -name "*.vim")  $(find ./ -mindepth 2 -name vimrc -o -name "*.vimrc" -o -name "*.vim") | base64)"
	echo 'local roxVimrcFile=/tmp/rox_vimrc_$(echo "$(whoami)" | base64_encode )'
	echo "echo '$vimrcEncodedContent' | base64_decode > \$roxVimrcFile"
	echo "echo \"\$roxVimrcFile\""
echo "}"

echo "function roxma_nvim_rcfile_name(){"
	echo 'local roxVimrcFile=/tmp/rox_nvimrc_$(echo "$(whoami)" | base64_encode )'
	echo "echo \"\$roxVimrcFile\""
echo "}"

echo "function roxma_nvim_rcfile_generate(){"
vimrcEncodedContent="$(cat $(find ./ -maxdepth 1 -name vimrc -o -name "*.vimrc" -o -name "*.vim")  $(find ./ -mindepth 2 -name vimrc -o -name "*.vimrc" -o -name "*.vim") | base64)"
    echo "echo '$vimrcEncodedContent' | base64_decode > \$(roxma_nvim_rcfile_name)"
echo "}"

echo "function roxma_vim_plugins_tgz_encoded(){"
	pluginsTgzEncodedContent="$(tar -cz plugins | base64)"
	echo "echo '$pluginsTgzEncodedContent'"
echo "}"

echo "function roxma_vim_plugins_tgz_encoded_content_md5sum(){"
	echo "echo '$(echo $pluginsTgzEncodedContent | md5sum)'"
echo "}"


cat init.sh

cat neovim.sh

