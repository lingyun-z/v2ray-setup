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

v2ray -config=config.json