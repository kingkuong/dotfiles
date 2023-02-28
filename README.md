# Setup

On a New Ubuntu machine, run:

```
sudo apt update

sudo apt install -y curl git ansible build-essential

mkdir ~/setup

cd ~/setup

git clone https://github.com/cuongtranx/dotfiles.git

cd dotfiles

./setup.sh
```

# Testing

This repo provides a Dockerfile to be used when testing with, run the command

```
docker build . -t local && docker run --rm -it && bash
cd setup
./setup
```
