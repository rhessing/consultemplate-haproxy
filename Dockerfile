FROM alpine:3.13.4

MAINTAINER R. Hessing

ENV CONSUL_TEMPLATE_VERSION=0.25.2

RUN apk --update add \
        bash \
        ca-certificates \
        haproxy \
        libnl3 \
        tini \
        wget \
        zip \
        && wget -O consul-template.zip https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip \
        && unzip consul-template.zip \
        && mv consul-template /usr/local/bin/consul-template \
        && chmod 755 /usr/local/bin/consul-template \
        && mkdir -p /etc/haproxy/static /etc/consul-template/config.d /etc/consul-template/template.d \
        && apk del wget zip \
        && rm -rf /consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip \
        && rm -rf /tmp/* \
        && rm /var/cache/apk/* \ 
        && rm -rf /var/lib/apt/lists/* \ 

COPY haproxy.hcl /etc/consul-template/config.d/haproxy.hcl
COPY haproxy-reload.sh /usr/local/bin/
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/docker-entrypoint.sh /usr/local/bin/haproxy-reload.sh

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/usr/local/bin/docker-entrypoint.sh"]
