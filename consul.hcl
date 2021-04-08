consul {
    address = "%%CONSUL_CLIENT_HTTPS%%"

    ssl {
        enabled = true
        verify = false
    }

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
