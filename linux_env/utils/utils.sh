#/bin/bash

set -o emacs

# npm
if which --skip-alias npm 2>/dev/null 1>/dev/null ; then
	alias cnpm="$(which --skip-alias npm) --registry=https://registry.npm.taobao.org \
		--cache=$HOME/.npm/.cache/cnpm \
		--disturl=https://npm.taobao.org/dist \
		--userconfig=$HOME/.cnpmrc"
fi

