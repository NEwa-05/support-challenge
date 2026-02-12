#!/bin/bash

# create wildcard certificate
cd certs/generated
openssl req -new -nodes -out gohello.csr -newkey rsa:4096 -keyout gohello.key -subj '/CN=gohello.localdemo.localhost/C=AT/ST=Paris/L=Paris/O=localdemo'
# create a v3 ext file for SAN properties
cat > gohello.v3.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = gohello.localdemo.localhost
EOF
openssl x509 -req -in gohello.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out gohello.crt -days 730 -sha256 -extfile gohello.v3.ext