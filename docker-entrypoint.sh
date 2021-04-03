#!/bin/sh
set -e

echo "Starting Consul template"
/usr/local/bin/consul-template -config /etc/consul-template/config.d
