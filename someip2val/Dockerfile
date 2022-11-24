FROM --platform=$BUILDPLATFORM ubuntu:20.04 as builder

ENV DEBIAN_FRONTEND="noninteractive"
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y && \
    apt-get install -y git \
    cmake g++ build-essential g++-aarch64-linux-gnu \
    binutils-aarch64-linux-gnu jq python3 python3-pip

RUN pip3 install conan

COPY . /src
WORKDIR /src

RUN ./build-release.sh $TARGETPLATFORM

FROM --platform=$TARGETPLATFORM ubuntu:20.04 as final
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y && \
    apt-get install -y jq
ARG TARGETARCH
COPY --from=builder "/src/target/*/release/install" "/install"
WORKDIR "/install/bin"

ENTRYPOINT "/install/bin/setup-someip2val.sh"