#! /usr/bin/env bash

set -eo pipefail

cd "$(dirname "$0")/.."

python ./litex_setup.py --init --install
