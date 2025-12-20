#! /usr/bin/env bash

set -eo pipefail

cd "$(dirname -- "$0")/.."

# Prepare Zephyr
west init zephyrproject
cd zephyrproject
west config manifest.group-filter -- -hal,-tools,-bootloader,-babblesim
west config manifest.project-filter -- -nrf_hw_models
west config --global update.narrow true
west update
west zephyr-export
west packages pip | xargs uv pip install

# Install Zephyr SDK
cd zephyr
west sdk install -H -t riscv64-zephyr-elf --install-base ../..

# Build Zephyr App
west build -b litex_vexriscv samples/philosophers/ -- -DDTC_OVERLAY_FILE= ../../zephyr-on-litex-vexriscv/overlay.dts
