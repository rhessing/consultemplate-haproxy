template {
  source = "/etc/haproxy/haproxy.ctmpl"
  destination = "/etc/haproxy/haproxy.cfg"
  command = "/usr/local/sbin/haproxy-reload.sh native /etc/haproxy/haproxy.cfg"
}
