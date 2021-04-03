FROM alpine:3.13.4

MAINTAINER R. Hessing

RUN apk --update add \
        bash \
        ca-certificates \
        haproxy \
        libnl3
        tini \
        zip \
        && rm -rf /tmp/* \
        && rm /var/cache/apk/* \ 
        && rm -rf /var/lib/apt/lists/*

ADD https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip /

RUN unzip /consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip \
   && mv /consul-template /usr/local/bin/consul-template \
   && mkdir -p /etc/consul-template/config.d /etc/consul-template/template.d \
   && rm -rf /consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip

ADD consul.cfg /etc/consul-template/config.d/consul.cfg
ADD haproxy-consul.cfg /etc/consul-template/config.d/haproxy.cfg
ADD haproxy.tmpl /etc/consul-template/template.d/haproxy.tmpl

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/usr/local/bin/docker-entrypoint.sh"]
