# see https://f4pga.readthedocs.io/en/latest/getting-started.html
# see https://f4pga-examples.readthedocs.io/en/latest/xc7/litex_demo.html
# try to adapt https://github.com/mgttu/f4pga-docker
# see https://docs.zephyrproject.org/latest/boards/riscv/litex_vexriscv/doc/index.html

FROM --platform=linux/amd64 ubuntu:latest

RUN apt update -y
RUN apt install -y git wget xz-utils

RUN git clone https://github.com/chipsalliance/f4pga-examples
WORKDIR /f4pga-examples

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O conda_installer.sh

# FIXME run as non root
ENV HOME=/root
ENV F4PGA_INSTALL_DIR=$HOME/opt/f4pga
ENV FPGA_FAM=xc7

RUN bash conda_installer.sh -u -b -p $F4PGA_INSTALL_DIR/$FPGA_FAM/conda
# # RUN source "$F4PGA_INSTALL_DIR/$FPGA_FAM/conda/etc/profile.d/conda.sh"
ENV CONDA_PYTHON_EXE=$F4PGA_INSTALL_DIR/$FPGA_FAM/conda/bin/python
ENV CONDA_EXE=$F4PGA_INSTALL_DIR/$FPGA_FAM/conda/bin/conda
ENV PATH=$F4PGA_INSTALL_DIR/$FPGA_FAM/conda/condabin:$F4PGA_INSTALL_DIR/$FPGA_FAM/conda/bin/:$PATH

# Create venv and activate it
RUN conda env create -f $FPGA_FAM/environment.yml
ENV PYTHONPATH=$F4PGA_INSTALL_DIR/$FPGA_FAM/conda/lib/python3.9/site-packages/

ENV F4PGA_PACKAGES='install-xc7 xc7a50t_test xc7a100t_test xc7a200t_test xc7z010_test'

RUN mkdir -p $F4PGA_INSTALL_DIR/$FPGA_FAM

ENV F4PGA_TIMESTAMP='20220920-124259'
ENV F4PGA_HASH='007d1c1'

RUN for PKG in $F4PGA_PACKAGES; do \
      wget -qO- https://storage.googleapis.com/symbiflow-arch-defs/artifacts/prod/foss-fpga-tools/symbiflow-arch-defs/continuous/install/${F4PGA_TIMESTAMP}/symbiflow-arch-defs-${PKG}-${F4PGA_HASH}.tar.xz | tar -vxJC $F4PGA_INSTALL_DIR/${FPGA_FAM} ; \
    done


WORKDIR /f4pga-examples/xc7/litex_demo
RUN pip install -r requirements.txt
# RUN src/litex/litex_setup.py init install

RUN apt install build-essential gcc-riscv64-unknown-elf