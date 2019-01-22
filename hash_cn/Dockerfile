# Multistage docker build, requires docker 17.05

# builder stage
FROM ubuntu:18.04 as builder

RUN set -ex && \
    apt-get update && \
    apt-get install -qq cmake build-essential cron openssl curl coreutils socat nginx git python openjdk-11-jre-headless

WORKDIR /opt/

## EMSDK
ARG EMCC_SDK_VERSION=sdk-1.38.11-64bit

RUN set -ex && git clone https://github.com/juj/emsdk.git /opt/emsdk
RUN set -ex && cd $EMCC_SDK_ROOT \
    && ./emsdk install $EMCC_SDK_VERSION \
    && ./emsdk activate $EMCC_SDK_VERSION

## WEBASM
ARG WEBASM_ROOT=/opt/webasm
COPY webassembly $WEBASM_ROOT

# RUN set -ex \
#    && /bin/bash -c "source $EMCC_SDK_ROOT/emsdk_env.sh"
    # \
    #&& cd $WEBASM_ROOT \
    # && /bin/bash -c "make"

# VOLUME ["/root"]

CMD ["/bin/bash","-c","source $EMCC_SDK_ROOT/emsdk_env.sh"]
