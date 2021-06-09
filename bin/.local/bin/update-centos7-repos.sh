#!/bin/bash

sudo yum install epel-release -y
sudo rpm -Uvh http://www.city-fan.org/ftp/contrib/yum-repo/rhel6/x86_64/city-fan.org-release-1-13.rhel6.noarch.rpm
sudo yum update curl
