FROM ubuntu:focal
ARG TAGS
RUN apt update
RUN apt install -y curl git ansible build-essential sudo
WORKDIR /usr/local/bin
COPY . ./setup/
CMD /bin/bash
