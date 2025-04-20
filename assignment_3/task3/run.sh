#!/bin/bash
qemu-system-aarch64 \
    -M raspi2 \
    -kernel kernel8.img \
    -nographic