#!/bin/bash
qemu-system-arm \
  -M raspi2b \
  -kernel kernel.img \
  -serial stdio \
  -nographic
