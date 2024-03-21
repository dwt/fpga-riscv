# Links

- [Docker Images for f4pga](https://github.com/mgttu/f4pga-docker)
- [How to use the Docker Images](https://hdl.github.io/containers/ug/AllInOne.html#f4pga)
- [What images exist and what do they contan](https://hdl.github.io/containers/ToolsAndImages.html#tools-and-images-f4pga)
- [How to run the picosec demo](https://f4pga-examples.readthedocs.io/en/latest/xc7/picosoc_demo.html)
- [Hardware Description Languages packages](https://github.com/hdl/packages)
- [Hardware Description Languages containers](https://github.com/hdl/containers)
- [Documentation for HDL containers](https://hdl.github.io/containers/)
- [Homebrew Repository for Open-Source FPGA Tools](https://github.com/ktemkin/homebrew-oss-fpga)
- [Arty A7 Reference Manual](https://digilent.com/reference/programmable-logic/arty-a7/reference-manual)
- [F4PGA hardware support status](https://f4pga.readthedocs.io/en/latest/status.html)
- [Zephyr Dependencies](https://docs.zephyrproject.org/latest/develop/getting_started/index.html#install-zephyr-sdk)
- [Zephyr installing west (build tool)](https://docs.zephyrproject.org/latest/develop/west/install.html)
- [Zephyr repo](https://github.com/zephyrproject-rtos/zephyr)
- [Zephyr how to build an application](https://github.com/zephyrproject-rtos/zephyr)
- [Zephyr LiteX VexRiscV](https://docs.zephyrproject.org/latest/boards/riscv/litex_vexriscv/doc/index.html)
-

# What we did

- Checkout f4pga-examples

  ```shell
  git clone https://github.com/chipsalliance/f4pga-examples
  cd f4pga-examples
  ```

- Start toolchain with docker

  ```shell
  docker run --rm -it \
      -v /$(pwd)://wrk \
      -w //wrk \
      gcr.io/hdl-containers/conda/f4pga/xc7/a50t
  ```

## Build picosec demo

- Run the toolchain in the container to generate the designs

  ```shell
  TARGET="arty_35" make -C xc7/picosoc_demo
  ```

- Install the `openFPGALoader` via homebrew and then run that on the host

  ```shell
  TARGET="arty_35" make -C xc7/picosoc_demo download
  ```

## Build VexRiscV CPU with old version of example code

- Install cross compilation toolchain (TODO check if this is really required fro this):

      apt update
      apt install gcc-riscv64-linux-gnu

- Build CPU

      # normaler build, kein ethernet, 32k rom
      ./src/litex/litex/boards/targets/arty.py --toolchain=symbiflow --cpu-type=vexriscv --sys-clk-freq 80e6 --output-dir build/vexriscv/arty_35 --variant a7-35 --build
      # ethernet, 64kb rom (32 lief über)
      ./src/litex/litex/boards/targets/arty.py --toolchain=symbiflow --cpu-type=vexriscv --sys-clk-freq 80e6 --output-dir build/vexriscv/arty_35 --variant a7-35 --build --with-ethernet --integrated-rom-size 65536

- Deploy

      openFPGALoader -b arty_a7_100t ./xc7/litex_demo/build/vexriscv/arty_35/gateware/arty.bit

- Connect via Serial: baud: 115200, data bits: 8, parity: none, stop bits: 1, path: /dev/cu.usbserial-210319B580D41 (serial port 2)

## Build VexRiscV CPU with current CPU Definitions via Zephyr Project

```shell
git clone --recursive https://github.com/litex-hub/zephyr-on-litex-vexriscv.git

cd zephyr-on-litex-vexriscv

# compilation needs to happen in container (slow, so make a checkpoint at some point after the build to speed up future builds)
docker run --rm -it \
      -v /$(pwd)://wrk \
      -w //wrk \
      gcr.io/hdl-containers/conda/f4pga/xc7/a50t

apt update
apt install gcc-riscv64-linux-gnu cmake
pip install requests packaging west

conda config --system --set always_yes yes
conda install -c timvideos gcc-riscv64-elf-nostdc openocd meson

source init

./make.py --board=arty --variant=a7-35 --build --toolchain=symbiflow --sys-clk-freq=80e6
```

now we can connect via serial (port 2!!)

```shell
openFPGALoader -b arty_a7_100t zephyr-on-litex-vexriscv/build/digilent_arty/gateware/digilent_arty.bit

mkdir west
cd west
west init .
west update
west zephyr-export
pip install -r zephyr/scripts/requirements.txt
```

### Was ging nicht

- in dem docker container zephyr bauen ist explodiet. Ausgerechnet tar…

### Was ging

Wir haben auf macos den zephyr sdk native installiert
https://docs.zephyrproject.org/latest/develop/getting_started/index.html#install-zephyr-sdk

    https://github.com/zephyrproject-rtos/sdk-ng/releases/

In `$HOME/.local/opt`

```shell
brew install cmake ninja meson

pipx install west
mkdir west
cd west
west init .
west update
west zephyr-export
mkvirtualenv west
pip install -r zephyr/scripts/requirements.txt

cd zephyr
west build -p always -b litex_vexriscv samples/hello_world

bash
cd zephyr-on-litex-vexriscv
source init
litex_term.py  /dev/tty.usbserial-210319B580D41 --speed 115200 --kernel ../west/zephyr/build/zephyr/zephyr.bin
```

# Serial Connection

- MacOS Tools (screen, kermit) sind nicht in der Lage sich mit 460800 baud auf eine Serielle zu verbinden
  - Versucht man es, kommen 9600 baud heraus.
  - Serial 2 geht!
- [stty kann angeblich dieses Setting einstellen](https://www.clearchain.com/blog/posts/using-serial-devices-in-freebsd-how-to-set-a-terminal-baud-rate)

# Nächste Schritte

- Zephyr
  - [Zephyr zum Laufen kriegen](https://docs.zephyrproject.org/latest/boards/riscv/litex_vexriscv/doc/index.html)
  - [Micropython darauf an den Start kriegen](https://docs.micropython.org/en/latest/zephyr/quickref.html)
- [Es gibt auch einen nativen Port von MicroPython auf VexRisc](https://www.hackster.io/matrix-labs/risc-v-soc-soft-core-w-micropython-on-matrix-voice-fpga-7be85c)
- [Hier hat auch jemand irgendwas mit GUI gebaut. Ist das relevant?](https://github.com/suarezvictor/litex_imgui_usb_demo)
- Hinkriegen das wir ein VGA output haben den wir via FrameBuffer ansprechen können. Unklar wo das her kommt, weil vermutlich noch nicht enthalten. [Hier gibts eine Demo wie man das integriert](https://projectf.io/posts/fpga-graphics/)
