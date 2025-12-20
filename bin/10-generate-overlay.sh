#! /usr/bin/env bash

set -eo pipefail

cd "$(dirname -- "$0")/.."
cd zephyr-on-litex-vexriscv

./third_party/litex/litex/tools/litex_json2dts_zephyr.py \
    --dts overlay.dts \
    --config overlay.config \
    ../linux-on-litex-vexriscv/build/orange_crab/csr.json
