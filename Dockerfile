FROM 'v2ray/official'
RUN apk add curl && apk add socat && apk add openssl && curl https://get.acme.sh | sh
COPY start.sh config.json /
RUN chmod 755 start.sh
EXPOSE 80
EXPOSE 443
CMD './start.sh'