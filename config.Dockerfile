FROM 'alpine:3.17'
RUN apk add curl && apk add socat && apk add openssl && curl https://get.acme.sh | sh
COPY gen-config.sh /
RUN chmod 755 gen-config.sh
EXPOSE 80
CMD './gen-config.sh'