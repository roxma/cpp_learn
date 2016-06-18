
all: 
	@echo done


# pathogen
all:  vim-pathogen.zip
vim-pathogen.zip:
	wget -O $@ https://github.com/tpope/vim-pathogen/archive/master.zip

# vim-plug
all: vim-plug.tar.gz
vim-plug.tar.gz:
	mkdir -p vim-plug/autoload
	wget -O vim-plug/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	tar  -zcf $@  vim-plug
	rm -rf vim-plug

