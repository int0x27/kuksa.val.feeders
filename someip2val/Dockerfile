FROM ubuntu:20.04

ENV DEBIAN_FRONTEND="noninteractive"
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y && \
    apt-get install -y git \
    cmake g++ build-essential g++-aarch64-linux-gnu \
    binutils-aarch64-linux-gnu jq python3 python3-pip

RUN pip3 install conan

COPY . /src
WORKDIR /src

ARG ARCH
ENV ARCH_ENV="${ARCH:-x86_64}"
#RUN echo $ARCH_ENV
RUN ./build-release.sh ${ARCH_ENV}
WORKDIR "/src/target/$ARCH_ENV/release/install/bin"

ENTRYPOINT "/src/target/$ARCH_ENV/release/install/bin/setup-someip2val.sh"