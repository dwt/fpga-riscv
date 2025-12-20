#! /usr/bin/env bash

set -eo pipefail

cd "$(dirname -- "$0")/.."

./litex-boards/litex_boards/targets/gsd_orangecrab.py --device=85F --build --timer-uptime
./litex/litex/tools/litex_json2dts_zephyr.py --dts build/gsd_orangecrab/overlay.dts --config build/gsd_orangecrab/overlay.config build/gsd_orangecrab/csr.json

echo results in $(pwd)/build/gsd_orangecrab/
