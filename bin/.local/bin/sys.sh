#!/usr/bin/env bash
_CPU=$(cat /proc/cpuinfo | grep 'cpu MHz' | awk '{print $4}')
_GLIBC=$(ls /lib/libc-*.so | awk -F- '/lib/ {print $2}' | awk -F. '{print $1"."$2}')
_HOSTNAME=$(hostname)
_HOSTTYPE=$(echo "$HOSTTYPE")
_KERNEL=$(uname -r | awk -F- '{print $1}')
_MACHINETYPE=$(echo "$MACHTYPE")
_MEM=$(cat /proc/meminfo | awk '/MemTotal/ {print $2 $3}')
_OSTYPE=$(echo "$OSTYPE")
_VENDOR=$(echo "$VENDOR")

echo '=============================='
echo 'CPU INFO ' "$_CPU"
echo 'GLIBC ' "$_GLIBC"
echo 'HOSTNAME ' "$_HOSTNAME"
echo 'HOSTTYPE ' "$_HOSTTYPE"
echo 'KERNEL ' "$_KERNEL"
echo 'MACHINETYPE ' "$_MACHINETYPE"
echo 'MEM INFO ' "$_MEM"
echo 'OSTYPE ' "$_OSTYPE"
echo 'VENDOR ' "$_VENDOR"
echo '=============================='
