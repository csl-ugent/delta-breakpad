# Build LLVM toolchain
FROM ubuntu:16.04 as llvm-builder
ARG DEBIAN_FRONTEND=noninteractive

# Install the packages required for building the toolchain
RUN \
  apt-get update && \
  apt-get install -y cmake g++ python

COPY modules/llvm /tmp/llvm/
RUN \
  mkdir -p /tmp/llvm/build/ && \
  cd /tmp/llvm/build/ && \
  cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/opt/llvm .. && \
  make -j$(nproc) install

# Actual docker image
FROM ubuntu:16.04

# Install the packages required for setup and running the scripts
RUN \
  apt-get update && \
  apt-get install -y python3 python3-gnupg python3-pip python ssh && \
  pip3 install pyexcel pyexcel-ods3

# Set up directory structure, copy in the required source for setup
COPY modules/SPEC_CPU2006v1.1.tar.bz2 /opt/
COPY modules/breakpad /opt/breakpad
COPY modules/regression /opt/regression
COPY --from=llvm-builder /opt/llvm /opt/llvm
COPY modules/scripts /opt/scripts

# Run the setup script
RUN ["/opt/scripts/setup.py"]

# Install the toolchain for actually building binaries
RUN \
  apt-get update && \
  apt-get install -y gcc-4.9-multilib-arm-linux-gnueabihf g++-4.9-multilib-arm-linux-gnueabihf

# Clean up
RUN rm /opt/SPEC_CPU2006v1.1.tar.bz2

WORKDIR "/opt/scripts"
ENTRYPOINT ["/opt/scripts/generate_all_results.py"]
