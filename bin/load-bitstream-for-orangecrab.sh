#! /usr/bin/env bash

set -eo pipefail

cd "$(dirname -- "$0")/.."
cd linux-on-litex-vexriscv

python ./make.py --board=orange_crab --cpu-count=1 --load
