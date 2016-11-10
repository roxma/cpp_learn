
# before executing this script,
# install nix with `curl https://nixos.org/nix/install | sh`
# The user installing nix needs sudo previlege

nix-env --install python3
nix-env --install git
nix-env --install lua
nix-env --install elixir
nix-env --install neovim
nix-env --install tmux
nix-env --install proxychains

# nix-env -i php-7.0.12
# 
# pecl config-set ext_dir ~/.pecl/ext_dir
# pecl config-set doc_dir ~/.pecl/doc_dir
# pecl config-set bin_dir ~/.pecl/bin_dir
# pecl config-set data_dir ~/.pecl/data_dir
# pecl config-set cfg_dir ~/.pecl/cfg_dir
# pecl config-set www_dir ~/.pecl/www_dir
# # pecl config-set man_dir ~/.pecl/man_dir
# # pecl config-set temp_dir ~/.pecl/temp_dir
# # pecl config-set temp ~/.pecl/temp
# # pecl config-set download_dir ~/.pecl/download_dir
# 
# pecl install redis
# pecl install mongodb

# nix-env --install llvm

# python-dev config
pip install --user neovim

