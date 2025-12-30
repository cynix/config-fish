set --global fish_key_bindings fish_default_key_bindings

fish_add_path $HOME/go/bin $HOME/.cargo/bin $HOME/.local/share/gem/ruby/bin
# Move these to the front
fish_add_path -m $HOME/.local/bin
fish_add_path -m $HOME/bin
