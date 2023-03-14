/root/.acme.sh/acme.sh --register-account -m $EMAIL --server zerossl && \
/root/.acme.sh/acme.sh --issue -d $DOMAIN --standalone -k ec-256 && \
/root/.acme.sh/acme.sh --installcert -d $DOMAIN --fullchainpath /etc/v2ray/v2ray.crt --keypath /etc/v2ray/v2ray.key --ecc && \
cat /etc/v2ray/v2ray.crt /etc/v2ray/v2ray.key > /etc/v2ray/v2ray.pem