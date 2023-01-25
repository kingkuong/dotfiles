FROM ubuntu:focal
ARG TAGS
WORKDIR /usr/local/bin
RUN apt update
RUN apt install -y curl git ansible build-essential sudo
RUN useradd -m docker && echo "docker:password" | chpasswd && adduser docker sudo
USER docker
COPY . ./setup/
CMD /bin/bash
