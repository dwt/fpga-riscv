#! /usr/bin/env bash

set -eo pipefail

cd "$(dirname -- "$0")/.."
cd orangecrab-examples/riscv/button/

make CROSS=riscv32-none-elf-
echo For this to work, the board needs to be connected, have a riscv core loaded and be in DFU mode.
dfu-util --alt 0 --download blink_fw.dfu
