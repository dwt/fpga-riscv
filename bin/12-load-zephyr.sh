#! /usr/bin/env bash

set -eo pipefail

cd "$(dirname -- "$0")/.."
cd zephyrproject/zephyr/

echo "exit with ctrl-c+ctrl-c relatively fast"
litex_term /dev/tty.usbmodem101 --kernel build/zephyr/zephyr.bin --safe
