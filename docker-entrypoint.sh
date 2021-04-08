#!/bin/sh
set -e

sed -i "s/%%CONSUL_CLIENT_HTTPS%%/${CONSUL_CLIENT_HTTPS}/g" /etc/consul-template/config.d/consul.hcl
sed -i "s/%%NOMAD_GROUP_NAME%%/${NOMAD_GROUP_NAME}/g" /etc/haproxy/static/default.html
sed -i "s/%%CONSUL_CLIENT_DNS%%/${CONSUL_CLIENT_DNS}/g" /etc/consul-template/template.d/haproxy.ctmpl


echo "Starting Consul template"
/usr/local/bin/consul-template -config /etc/consul-template/config.d
