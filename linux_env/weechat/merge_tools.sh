
echo "function roxma_weechat_scripts_tgz(){"
	echo "cat <<< '$(tar -cz lua | base64)' | base64_decode"
echo "}"

cat init.sh

