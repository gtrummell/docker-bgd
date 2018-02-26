#!/bin/sh

export CONSUL_ADDR=${CONSUL_ADDR}

/usr/bin/consul-template \
    -log-level=info \
    -template=/etc/consul-template/nginx.conf.ctmpl:/etc/nginx/nginx.conf \
    -consul-addr=${CONSUL_ADDR} \
    -exec="/usr/sbin/nginx -c /etc/nginx/nginx.conf"
