#!/bin/bash
qemu-system-arm \
  -M raspi2 \
  -kernel kernel.img \
  -serial stdio \
  -nographic
