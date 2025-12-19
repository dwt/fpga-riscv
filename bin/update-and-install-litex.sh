#! /usr/bin/env bash

set -eo pipefail

cd "$(dirname "$0")/.."

env -C litex python litex_setup.py --init --update --install
