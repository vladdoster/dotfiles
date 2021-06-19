#!/bin/bash

trap 'error' ERR

error() {
    echo "ERROR: Failed to update CentOS7 repositories"
    exit 1
}

echo "--- Installing EPEL repository"
sudo yum install epel-release -y
echo "--- Installing city-fan repository"
sudo rpm -Uvh http://www.city-fan.org/ftp/contrib/yum-repo/rhel6/x86_64/city-fan.org-release-1-13.rhel6.noarch.rpm
echo "--- Updating cURL"
sudo yum update curl
echo "--- Refreshing CentOS7 repositories"
sudo yum update && sudo yum upgrade
echo "--- Updated CentOS7 repositories"
