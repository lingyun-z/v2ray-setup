apt update && apt install docker.io && apt install docker-compose

docker network create v2ray

docker build -f config.Dockerfile -t v2raysetup_config:latest . && \
docker run --env-file .env -p 80:80 -v /etc/v2ray:/etc/v2ray -v /etc/nginx:/etc/nginx -v /etc/haproxy:/etc/haproxy -d v2raysetup_config:latest sh gen-config.sh
docker run -v /etc/haproxy:/usr/local/etc/haproxy -v /etc/v2ray:/etc/ssl/private -it 7e518a5eac13 /bin/sh
