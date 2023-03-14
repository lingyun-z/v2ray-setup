docker run --env-file .env -p 80:80 -v /etc/v2ray:/etc/v2ray -d v2raysetup_crt:latest sh gen-crt.sh
