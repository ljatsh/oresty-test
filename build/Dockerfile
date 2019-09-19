
# 基于18.10 https://hub.docker.com/_/ubuntu
FROM ubuntu:cosmic

MAINTAINER longjun.wang@qq.com

ARG OPENRESTY_VERSION=1.15.8.2
ARG RESTY_LUAROCKS_VERSION="2.4.4"

# download purpose ---> curl
# build purpose ---> make gcc build-essential libpcre3-dev libssl-dev perl zlib1g-dev
# dev purpose ---> telnet
RUN apt-get update && \
    apt-get install -y curl make gcc && \
    apt-get install -y build-essential libpcre3-dev libssl-dev perl zlib1g-dev && \
    apt-get install -y telnet

# install OpenResty
RUN cd /tmp && \
    curl -fSL https://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz -o openresty-${OPENRESTY_VERSION}.tar.gz --progress && \
    tar -xvf openresty-${OPENRESTY_VERSION}.tar.gz && \
    cd openresty-${OPENRESTY_VERSION} && \
    ./configure && \
    make install

#install test:nginx
RUN cpan -f -i Test::Nginx

#TODO
RUN apt-get install -y unzip
#install busted
RUN cd /tmp \
    && curl -fSL https://github.com/luarocks/luarocks/archive/${RESTY_LUAROCKS_VERSION}.tar.gz -o luarocks-${RESTY_LUAROCKS_VERSION}.tar.gz --progress \
    && tar -xvf luarocks-${RESTY_LUAROCKS_VERSION}.tar.gz \
    && cd luarocks-${RESTY_LUAROCKS_VERSION} \
    && ./configure \
        --prefix=/usr/local/openresty/luajit \
        --with-lua=/usr/local/openresty/luajit \
        --lua-suffix=jit-2.1.0-beta3 \
        --with-lua-include=/usr/local/openresty/luajit/include/luajit-2.1 \
    && make build \
    && make install \
    && cd /tmp \
    && rm -rf luarocks-${RESTY_LUAROCKS_VERSION} luarocks-${RESTY_LUAROCKS_VERSION}.tar.gz
# TODO
RUN apt-get install -y git
# 配套的busted版本不合适，安装最新的版本
RUN /usr/local/openresty/luajit/bin/luarocks install lua-resty-busted && \
    /usr/local/openresty/luajit/bin/luarocks install busted 2.0.0-1 && \
    /usr/local/openresty/luajit/bin/luarocks remove --force busted 2.0.rc11

# sdp lpack
COPY external/sdp /tmp/sdp
RUN cd /tmp/sdp && /usr/local/openresty/luajit/bin/luarocks make
COPY external/lpack /tmp/lpack
RUN cd /tmp/lpack && /usr/local/openresty/luajit/bin/luarocks make

# Add additional binaries into PATH for convenience
ENV PATH=$PATH:/usr/local/openresty/luajit/bin:/usr/local/openresty/nginx/sbin:/usr/local/openresty/bin

CMD ["/bin/bash"]
#CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]

#docker build --force-rm -t openresty:cosmic -f Dockerfile .
