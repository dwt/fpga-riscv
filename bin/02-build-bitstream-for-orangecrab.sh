#! /usr/bin/env bash

set -eo pipefail

cd "$(dirname -- "$0")/.."
cd linux-on-litex-vexriscv
./make.py --board=orange_crab --cpu-count=1 --build --device=85F
