# PREPARATION
BUNDLE=$HOME/.vim/bundle
YCM=$BUNDLE/YouCompleteMe
mkdir -p $BUNDLE
#
# PRE-REQUESITE
#   node.js
#   vim compiled with python included
# On Linux system, make sure these libraries are installed
#   sudo apt-get install build-essential cmake
#   sudo apt-get install python-dev python3-dev
#
# INSTALLATION
git clone https://github.com/Valloric/YouCompleteMe.git $YCM
cd $YCM
git submodule update --init --recursive
# This will install YCM with syntax support for C-family language, Python and Javascript
./install.py --clang-completer --tern-completer
