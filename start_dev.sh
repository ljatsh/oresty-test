#!/bin/bash

dir=$(cd `dirname $0`; pwd)

docker run --name openresty --rm \
-p 8010:80 \
openresty:cosmic
