#!/bin/bash

sudo vim /etc/yum.repos.d/hashicorp.repo

[hashicorp]
name=HashiCorp Stable - $basearch
baseurl=https://rpm.releases.hashicorp.com/fedora/$releasever/$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://rpm.releases.hashicorp.com/gpg

dnf repolist

sudo dnf5 install terraform

terraform --version

