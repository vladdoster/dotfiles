#!/bin/bash

trap 'error' ERR

error() {
    echo "ERROR: Failed to update CentOS7 repositories"
    exit 1
}

echo "--- Installing EPEL repository"
sudo yum install epel-release -y
echo "--- Installing city-fan repository"
sudo rpm -Uvh http://www.city-fan.org/ftp/contrib/yum-repo/city-fan.org-release-2-1.rhel7.noarch.rpm || true
sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm || true
sudo yum -y --enablerepo=city-fan.org install curl
echo "--- Updating cURL"
sudo yum update curl git docker
echo "--- Refreshing CentOS7 repositories"
sudo yum update && sudo yum upgrade
echo "--- Updated CentOS7 repositories"
