docker run --env DOMAIN=v2ray-test.eastasia.cloudapp.azure.com --env EMAIL=test@example.com -p 80:80 -p 443:443 -v ~/v2ray/config:/etc/v2ray -d v2ray_v2ray:latest sh start.sh
