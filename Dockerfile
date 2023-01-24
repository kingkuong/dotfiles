FROM ubuntu:focal
ARG TAGS
WORKDIR /usr/local/bin
RUN apt update && apt install -y software-properties-common && sudo -E apt-add-repository -y --update ppa:ansible/ansible && apt install -y curl git ansible build-essential
COPY . .
CMD ["sh", "-c", "ansible-playbook $TAGS local.yml"]
