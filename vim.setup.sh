# Preparation
BUNDLE=$HOME/.vim/bundle
AUTOLOAD=$HOME/.vim/autoload
# removed existing bundle
rm -rf $BUNDLE $AUTOLOAD

# Install Plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
