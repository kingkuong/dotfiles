# Setup

## Ubuntu

```
sudo apt update

sudo apt install -y curl git ansible build-essential

mkdir ~/setup

cd ~/setup

git clone https://github.com/cuongtranx/dotfiles.git

cd dotfiles

./setup.sh
```

## Arch

TBD

## OSX

TBD

## Common operations

* To run tasks with tag:

`ansible-playbook ./local.yml --tags git`

Tips: provide one time tag to run command one time



# Testing

This repo provides a Dockerfile to be used when testing with, run the command

```
docker build . -t local && docker run --rm -it local ansible-playbook ./setup/local.yml --ask-vault-pass

docker run --rm -it local zsh
```
