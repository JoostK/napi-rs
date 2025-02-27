FROM node:lts-stretch

ARG NASM_VERSION=2.15.05

ENV RUSTUP_HOME=/usr/local/rustup \
  CARGO_HOME=/usr/local/cargo \
  PATH=/usr/local/cargo/bin:$PATH \
  CC=clang \
  CXX=clang++

RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
  echo "deb http://apt.llvm.org/stretch/ llvm-toolchain-stretch main" >> /etc/apt/sources.list && \
  echo "deb-src http://apt.llvm.org/stretch/ llvm-toolchain-stretch main" >> /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y --fix-missing --no-install-recommends \
  curl \
  llvm \
  clang \
  lld \
  libc++-13-dev \
  libc++abi-13-dev \
  xz-utils \
  rcs \
  git \
  make \
  gcc-aarch64-linux-gnu \
  g++-aarch64-linux-gnu \
  gcc-arm-linux-gnueabihf \
  g++-arm-linux-gnueabihf \
  ninja-build && \
  apt-get autoremove -y && \
  curl https://sh.rustup.rs -sSf | sh -s -- -y && \
  rustup target add aarch64-unknown-linux-gnu && \
  rustup target add armv7-unknown-linux-gnueabihf && \
  npm install -g pnpm lerna && \
  ln -sf /usr/bin/clang /usr/bin/cc

RUN wget https://www.nasm.us/pub/nasm/releasebuilds/${NASM_VERSION}/nasm-${NASM_VERSION}.tar.xz && \
  tar -xf nasm-${NASM_VERSION}.tar.xz && \
  cd nasm-${NASM_VERSION} && \
  ./configure --prefix=/usr/ && \
  make && \
  make install && \
  cd / && \
  rm -rf nasm-${NASM_VERSION} && \
  rm nasm-${NASM_VERSION}.tar.xz
