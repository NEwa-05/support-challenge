#!/bin/bash

cd ./certs/generated
# generate aes encrypted private key
openssl genrsa -out ca.key 4096
# create certificate, 1826 days = 5 years
openssl req -x509 -new -nodes -key ca.key -sha256 -days 1826 -out ca.crt -subj '/CN=localdemo CA/C=AT/ST=Paris/L=Paris/O=localdemo'
# create wildcard certificate
openssl req -new -nodes -out localwildcard.csr -newkey rsa:4096 -keyout localwildcard.key -subj '/CN=localdemo.localhost/C=AT/ST=Paris/L=Paris/O=localdemo'
# create a v3 ext file for SAN properties
cat > localwildcard.v3.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = *.localdemo.localhost
DNS.2 = .localdemo.localhost
EOF
openssl x509 -req -in localwildcard.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out localwildcard.crt -days 730 -sha256 -extfile localwildcard.v3.ext
