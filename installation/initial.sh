sudo apt-get update
sudo apt-get upgrade -y

# ======================================
# Essentials 
# ======================================
# zsh & oh-my-zsh
sudo apt-get install -y zsh curl
chsh -s /bin/zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# terminator, vim, tmux, git
sudo apt-get install -y vim tmux git terminator

# vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# enable nfs
sudo apt-get install -y nfs-kernel-server

# virtualbox & vagrant
sudo apt-get install -y virtualbox vagrant

# ======================================
# Python 
# ======================================
sudo apt-get install -y python-pip python-dev build-essential
sudo apt-get install -y python3-dev python3-pip
sudo pip install --upgrade -y pip
sudo pip3 install --upgrade -y pip
sudo pip install --upgrade -y virtualenv

# ======================================
# Utilities 
# ======================================
sudo apt-get install -y gimp cheese audacity calibre

# flux
sudo apt-get install git python-appindicator python-xdg python-pexpect python-gconf python-gtk2 python-glade2 -y
cd /tmp
git clone "https://github.com/xflux-gui/xflux-gui.git"
cd xflux-gui
sudo python ./setup.py install
