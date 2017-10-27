# Preparation
BUNDLE=$HOME/.vim/bundle
AUTOLOAD=$HOME/.vim/autoload
mkdir -p $BUNDLE $AUTOLOAD

# Install Vundle
git clone https://github.com/VundleVim/Vundle.vim.git $BUNDLE/Vundle.vim

# Install Pathogen and plugin managed by Pathogen:
curl -LSso $AUTOLOAD/pathogen.vim https://tpo.pe/pathogen.vim

cd $BUNDLE
git clone https://github.com/python-mode/python-mode.git
git clone git://github.com/tpope/vim-unimpaired.git
git clone git://github.com/tpope/vim-speeddating.git
