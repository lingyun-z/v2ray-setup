#!/bin/sh
# generate uuid
echo "
{
  \"inbounds\": [
    {
      \"port\": 443,
      \"protocol\": \"vmess\",
      \"settings\": {
        \"clients\": [
          {
            \"id\": \"$UUID\",
            \"alterId\": 64
          }
        ]
      },
      \"streamSettings\": {
        \"network\": \"tcp\",
        \"security\": \"tls\",
        \"tlsSettings\": {
          \"certificates\": [
            {
              \"certificateFile\": \"/etc/v2ray/v2ray.crt\",
              \"keyFile\": \"/etc/v2ray/v2ray.key\"
            }
          ]
        }
      }
    }
  ],
  \"outbounds\": [
    {
      \"protocol\": \"freedom\",
      \"settings\": {}
    }
  ]
}
" >> config.json

mkdir config
echo "
{
  \"inbounds\": [
    {
      \"port\": 443,
      \"protocol\": \"vmess\",
      \"settings\": {
        \"clients\": [
          {
            \"id\": \"$UUID\",
            \"alterId\": 64
          }
        ]
      },
      \"streamSettings\": {
        \"network\": \"tcp\",
        \"security\": \"tls\",
        \"tlsSettings\": {
          \"certificates\": [
            {
              \"certificateFile\": \"/etc/v2ray/v2ray.crt\",
              \"keyFile\": \"/etc/v2ray/v2ray.key\"
            }
          ]
        }
      }
    }
  ],
  \"outbounds\": [
    {
      \"protocol\": \"freedom\",
      \"settings\": {}
    }
  ]
}
" >> config/client.json

/root/.acme.sh/acme.sh --register-account -m $EMAIL --server zerossl && \
/root/.acme.sh/acme.sh --issue -d $DOMAIN --standalone -k ec-256 && \
/root/.acme.sh/acme.sh --installcert -d $DOMAIN --fullchainpath /etc/v2ray/v2ray.crt --keypath /etc/v2ray/v2ray.key --ecc && \
v2ray -config=config.json