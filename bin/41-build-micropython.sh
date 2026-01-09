#! /usr/bin/env bash

set -eo pipefail

cd "$(dirname -- "$0")/.."
cd micropython/ports/litex

BUILD_DIRECTORY=../../../linux-on-litex-vexriscv/build/orange_crab make V=1
