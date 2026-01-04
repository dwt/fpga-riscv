# this needs a cross compiler, see https://nix.dev/tutorials/cross-compilation.html
# trying to just add it to the build inputs to see if that can work.
{
  pkgs ? import <nixpkgs> { },
  python ? pkgs.python312,
}:
pkgs.mkShell {
  env = {
    # gcc marks itself as not supported for riscv32-embedded. Strange enough the packages are cached and working though. ¿¿¿
    NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM = 1;
  };
  nativeBuildInputs = with pkgs.buildPackages; [
    # FPGA tools - build rics5 core for Lattice ECP5 FPGA
    trellis # Lattice ECP5 open source bitstream tools
    yosys # open source synthesis tool
    nextpnr # FPGA place and route tool

    # Linux on LiteX dependencies
    dtc # device tree compiler
    wget # http fetcher
    git # version control system
    python.pkgs.setuptools
    python.pkgs.pip
    pkgsCross.riscv32-embedded.gcc # cross compiler to riscv

    ## only for simulation
    # verilator
    # libevent
    # json_c
    ## onlly for hardware test
    # openocd

    # Build Linux for risc5
    # not yet available for darwin :-(
    # coreboot-toolchain.riscv
    meson
    ninja
    dfu-util
    python.pkgs.west # build tool for zepyr rtos
    cmake
    python
    uv

    # openocd # Free and Open On-Chip Debugging, In-System Programming and Boundary-Scan Testing

  ];

  shellHook = /* bash */ ''
    if [ ! -d ".venv" ]; then
      uv venv --python "${pkgs.lib.getExe python}"
    fi
    source .venv/bin/activate
    export PATH=$PWD/bin:"$PATH"

    if [ ! -d linux-on-litex-vexriscv ]; then
        git clone https://github.com/litex-hub/linux-on-litex-vexriscv
        (
            cd linux-on-litex-vexriscv/images
            wget https://github.com/litex-hub/linux-on-litex-vexriscv/files/8331338/linux_2022_03_23.zip
        )
    fi

    if [ ! -d orangecrab-examples ]; then
        git clone https://github.com/orangecrab-fpga/orangecrab-examples
    fi

    if [ ! -d litex ]; then
        git clone git@github.com:enjoy-digital/litex.git
        env -C litex python litex_setup.py --init --install
    fi
  '';
}

# install litex
# clone
# cd litex
# python ./litex_setup.py --init --install

# install via homebrew
# brew install riscv64-elf-gcc riscv64-elf-binutils

# If I want litex simulation
# $ brew install json-c verilator libevent
# $ brew cask install tuntap
# $ litex_sim --cpu-type=vexriscv

# cd ..
# git clone https://github.com/litex-hub/linux-on-litex-vexriscv
# ❯ cd linux-on-litex-vexriscv/
# ❯ ./make.py --board=orange_crab --cpu-count=1 --build --device=85F
# ❯ ./make.py --board=orange_crab --cpu-count=1 --load
### ❯ litex_term --images=images/boot.json /dev/tty.usbmodem2101
# in images
# curl -OL https://github.com/litex-hub/linux-on-litex-vexriscv/files/8331338/linux_2022_03_23.zip
# gunzip linux_2022_03_23.zip
# cd top des projektes
# ❯ litex_term --images=images/linux_2022_03_23/boot.json /dev/tty.usbmodem2101

# This actually works, after we changed the makefile to compile for 85F
# cd orangecrab-examples/verilog/blink
# make
# make dfu

# muss unter linux gebaut werden
# git clone http://github.com/buildroot/buildroot
# cd buildroot/support/docker/
# docker build --platform linux/amd64 . -t buildroot
## switch docker desktop to use qemu for x86_64 emulation
# docker run --rm -it -v (pwd)/../..:/home/br-user/buildroot -v (pwd)/../../../linux-on-litex-vexriscv/:/home/br-user/linux-on-litex-vexriscv  buildroot:latest  bash
# cd buildroot
# make distclean
# make BR2_EXTERNAL=../linux-on-litex-vexriscv/buildroot/ litex_vexriscv_defconfig
# make -j 16
