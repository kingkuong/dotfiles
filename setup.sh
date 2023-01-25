#!/usr/bin/env bash

ansible-playbook ./local.yml --ask-become-pass --ask-vault-pass
