
# 基于18.10 https://hub.docker.com/_/ubuntu
FROM ubuntu:cosmic

MAINTAINER longjun.wang@qq.com

ARG OPENRESTY_VERSION=1.15.8.2

# download purpose ---> curl
# build purpose ---> make gcc build-essential libpcre3-dev libssl-dev perl zlib1g-dev
RUN apt-get update && \
    apt-get install -y curl make gcc && \
    apt-get install -y build-essential libpcre3-dev libssl-dev perl zlib1g-dev

# install OpenResty
RUN cd /tmp && \
    curl -fSL https://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz -o openresty-${OPENRESTY_VERSION}.tar.gz --progress && \
    tar -xvf openresty-${OPENRESTY_VERSION}.tar.gz && \
    cd openresty-${OPENRESTY_VERSION} && \
    ./configure && \
    make install

RUN ln -sf /dev/stdout /usr/local/openresty/nginx/logs/access.log && \
    ln -sf /dev/stderr /usr/local/openresty/nginx/logs/error.log

# Add additional binaries into PATH for convenience
ENV PATH=$PATH:/usr/local/openresty/luajit/bin:/usr/local/openresty/nginx/sbin:/usr/local/openresty/bin

CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]

#docker build --force-rm -t openresty:cosmic -f Dockerfile .
