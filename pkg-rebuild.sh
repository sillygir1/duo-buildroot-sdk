#!/bin/bash

if [ $1 == '' ]; then
    echo "Please specify package name"
    exit 1
fi

cd /home/work

source device/milkv-duo256m-sd/boardconfig.sh
source build/milkvsetup.sh
defconfig cv1812cp_milkv_duo256m_sd

cd buildroot-2021.05

make "$1"-dirclean
make "$1"
