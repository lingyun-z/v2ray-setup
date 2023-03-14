# generate crt
/root/.acme.sh/acme.sh --register-account -m $EMAIL --server zerossl && \
/root/.acme.sh/acme.sh --issue -d $DOMAIN --standalone -k ec-256 && \
/root/.acme.sh/acme.sh --installcert -d $DOMAIN --fullchainpath /etc/v2ray/v2ray.crt --keypath /etc/v2ray/v2ray.key --ecc && \
cat /etc/v2ray/v2ray.crt /etc/v2ray/v2ray.key > /etc/v2ray/v2ray.pem

# generate v2ray config
echo "
{
  \"inbounds\": [
    {
      \"protocol\": \"vmess\",
      \"listen\": \"127.0.0.1\",
      \"port\": 40001,
      \"settings\": {
        \"clients\": [
          {
            \"id\": \"$UUID\"
          }
        ]
      },
      \"streamSettings\": {
        \"network\": \"tcp\"
      }
    }
  ],
  \"outbounds\": [
    {
      \"protocol\": \"freedom\"
    }
  ]
}
"> /etc/v2ray/config.json

echo "
{
  \"inbounds\": [
    {
      \"port\": 1080,
      \"listen\": \"127.0.0.1\",
      \"protocol\": \"socks\"
    }
  ],
  \"outbounds\": [
    {
      \"protocol\": \"vmess\",
      \"settings\": {
        \"vnext\": [
          {
            \"address\": \"$DOMAIN\",
            \"port\": 443,
            \"users\": [
                {
                  \"id\": \"$UUID\",
                  \"security\": \"none\"
                }
            ]
          }
        ]
      },
      \"streamSettings\": {
        \"network\": \"tcp\",
        \"security\": \"tls\"
      }
    }
  ]
}
" > /etc/v2ray/client.json

# generate nginx config
echo "
events {
  worker_connections  1024;
}

http {
  server {
    listen 8080;
    server_name localhost;
    root /var/www/html;
  }
}
" > /etc/nginx/nginx.conf

# generate haproxy config
echo "
global
    log /dev/log local0
    log /dev/log local1 notice
    chroot /var/lib/haproxy
    stats socket ~/admin.sock mode 660 level admin expose-fd listeners
    stats timeout 30s
    user haproxy
    group haproxy
    daemon
    ca-base /etc/ssl/certs
    crt-base /etc/ssl/private

    ssl-default-bind-ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
    ssl-default-bind-ciphersuites TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
    
    ssl-default-bind-options no-sslv3 no-tlsv10 no-tlsv11

    tune.ssl.default-dh-param 2048

defaults
    log global 
    mode tcp
    option dontlognull
    timeout connect 5s
    timeout client  300s
    timeout server  300s

frontend tls-in
    bind *:443 tfo ssl crt /etc/ssl/private/v2ray.pem
    tcp-request inspect-delay 5s
    tcp-request content accept if HTTP
    use_backend web if HTTP
    default_backend vmess

backend web
    server server1 nginx:8080
  
backend vmess
    server server1 v2ray:40001
" > /etc/haproxy/haproxy.cfg