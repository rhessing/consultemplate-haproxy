#!/bin/sh
set -e

cat << EOF >> /etc/consul-template/config.d/consul.hcl
consul {
    address = "${CONSUL_CLIENT_HTTPS}"
    retry {
        enabled = true
        attempts = 12
        backoff = "250ms"
    }
}

reload_signal = "SIGHUP"
kill_signal = "SIGINT"
max_stale = "10m"
log_level = "warn"
pid_file = "/run/consul-template.pid"

wait {
    min = "5s"
    max = "10s"
}

EOF

cat << EOF >> /etc/haproxy/static/default.html
<!DOCTYPE html>
<html>
<head>
<title>Default LB</title>
</head>
<body>

<h1>${NOMAD_GROUP_NAME}</h1>

</body>
</html> 
EOF

cat << EOF >> /etc/consul-template/template.d/haproxy.ctmpl
global
    log /dev/log local0
    log /dev/log local1 notice
    chroot /var/lib/haproxy
    stats socket /var/run/haproxy_admin.sock mode 660 level admin
    pidfile /var/run/haproxy.pid
    user  haproxy
    group haproxy
    daemon

defaults
    log    global
    mode   http
    option httplog
    option dontlognull
    timeout connect 50000
    timeout client  50000
    timeout server  50000

resolvers consul
    nameserver consul ${COSUL_CLIENT_DNS}
    accepted_payload_size 8192
    hold valid 3s

frontend http_front
    bind *:80
    use_backend %[req.hdr(host),lower,word(1,:)]
    default_backend haproxy

backend haproxy
    mode http
    http-request set-log-level silent
    errorfile 503 /etc/haproxy/static/default.html

{{ range $i, $service := services }}{{ range $tag := .Tags }}{{ if $tag | regexMatch "^domain=.+" }}{{ $domain := index (. | split "=") 1 }}{{ if $service.Tags | contains "edge" }}
backend {{$domain}}
  server-template {{$service.Name}} 10 _{{$service.Name}}._tcp.service.consul resolvers consul resolve-opts allow-dup-ip resolve-prefer ipv4 check
{{end}}{{end}}{{end}}{{end}}
EOF

echo "Starting Consul template"
/usr/local/bin/consul-template -config /etc/consul-template/config.d
