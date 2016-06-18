
echo "function roxma_tmux_conf_generate() {"
vimrcEncodedContent="$(cat ./tmux.conf | base64)"
    cat <<< "cat <<< '$vimrcEncodedContent' | base64_decode"
echo "}"

echo "function roxma_tmux_powerline_conf_generate() {"
vimrcEncodedContent="$(cat ./tmux-powerline.conf | base64)"
    cat <<< "cat <<< '$vimrcEncodedContent' | base64_decode"
echo "}"

cat init.sh

