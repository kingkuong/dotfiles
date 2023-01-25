FROM ubuntu:focal
ARG TAGS
WORKDIR /usr/local/bin
RUN apt update
RUN apt install -y curl git ansible build-essential
COPY . .
