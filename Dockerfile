FROM ubuntu:focal
ARG TAGS
WORKDIR /usr/local/bin
RUN apt update
#RUN apt install -y software-properties-common
#RUN apt-add-repository -y -u ppa:ansible/ansible
RUN apt install -y curl git ansible build-essential
COPY . .
CMD ["sh", "-c", "ansible-playbook $TAGS local.yml"]
