#!/usr/bin/env bash
if [ "$1" == 'set-defconfig' ]
then
    docker exec -it duodocker /bin/bash -c "cd /home/work/buildroot-2021.05 && make milkv-duo256m-sd_musl_riscv64_defconfig"
elif [ "$1" == 'build' ]
then
    time docker exec -it duodocker /bin/bash -c "cd /home/work/ && rm -rf buildroot-2021.05/output/milkv-duo256m_musl_riscv64/build/proxmark3* && rm -rf buildroot-2021.05/output/milkv-duo256m_musl_riscv64/build/encoder* && ./build.sh milkv-duo256m-sd"
    notify-send -a "Docker" -u critical -w "Run finished"
elif [ "$1" == "pkg" ]
then
    if [ "$2" == '' ]
    then
        echo "Usage: ./docker.sh pkg package_name"
        exit 1
    fi
    docker exec -it duodocker /bin/bash -c "./home/work/pkg-rebuild.sh $2"
else
    echo "Avaliable options: build, pkg, set-defconfig"
fi
