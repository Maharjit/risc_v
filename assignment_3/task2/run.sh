#!/bin/bash
qemu-system-aarch64 \
  -M raspi2 \
  -cpu cortex-a7 \
  -m 1024 \
  -nographic \
  -kernel kernel8.img
