template {
  source = "/etc/consul-template/template.d/haproxy.ctmpl"
  destination = "/etc/haproxy/haproxy.cfg"
  command = "/usr/local/bin/haproxy-reload.sh native /etc/haproxy/haproxy.cfg"
}
