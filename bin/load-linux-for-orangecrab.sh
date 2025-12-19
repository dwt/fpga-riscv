#! /usr/bin/env bash

set -eo pipefail

cd "$(dirname -- "$0")/.."
cd linux-on-litex-vexriscv

#litex_term --images=images/boot.json /dev/ttyUSBX (--safe : In case of CRC Error, slower but should always work)
litex_term --images=images/linux_2022_03_23/boot.json /dev/tty.usbmodem1101 --safe # (--safe : In case of CRC Error, slower but should always work)
