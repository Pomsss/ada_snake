#!/bin/sh

rm -rf obj/
source env.sh
gprbuild && arm-none-eabi-objcopy -O binary obj/main obj/main.bin
st-flash write obj/main.bin 0x8000000
