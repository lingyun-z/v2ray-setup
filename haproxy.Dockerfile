FROM haproxy:2.5-alpine
USER root
RUN mkdir --parents /var/lib/haproxy && chown -R haproxy:haproxy /var/lib/haproxy
RUN mkdir /run/haproxy
CMD ["haproxy", "-f", "/usr/local/etc/haproxy/haproxy.cfg"]