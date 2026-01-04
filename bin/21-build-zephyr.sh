#! /usr/bin/env bash

set -eo pipefail

cd "$(dirname -- "$0")/.."
cd zephyrproject/zephyr

rm -rf build
west build -b litex_vexriscv samples/philosophers/ -DDTC_OVERLAY_FILE="$(realpath ../../build/gsd_orangecrab/overlay.dts)"
