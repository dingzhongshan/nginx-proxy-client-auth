# nginx-proxy-client-auth #
## nginx-proxy-client-auth ##

based on: https://github.com/jwilder/nginx-proxy

### generate wild-card cert
.openssl genrsa 2048 > local-wildcard.key
.openssl req -new -x509 -nodes -sha1 -days 3650 -key local-wildcard.key > local-wildcard.cert
.for the above step, step is keyed to use .local along with nginx proxy (i.e., openssl req -new -x509 -nodes ...
>
    Country Name (2 letter code) [AU]:US
    State or Province Name (full name) [Some-State]:State
    Locality Name (eg, city) []:City
    Organization Name (eg, company) [Internet Widgits Pty Ltd]:test
    Organizational Unit Name (eg, section) []:IT
    Common Name (eg, YOUR name) []:*.local
    Email Address []:webmaster@local
>

  .openssl x509 -noout -fingerprint -text < local-wildcard.cert > local-wildcard.info
  .cat local.crt local.key > local.pem
  .chmod 644 local.key local.pem
  .openssl x509 -in local.pem -noout -text

  ### generate first client
  .openssl genrsa -des3 -out user1-local.key 4096
  .openssl req -new -key user1-local.key -out user1-local.csr
  .openssl x509 -req -days 365 -in user1-local.csr -CA local.crt -CAkey local.key -set_serial 01 -out user1-local.crt
  .openssl pkcs12 -export -out user1-local.pfx -inkey user1-local.key -in user1-local.crt -certfile local.crt
  .import cert pfx into browser

  ### generate second client
  .openssl genrsa -des3 -out user2-local.key 4096
  .openssl req -new -key user2-local.key -out user2-local.csr
  .openssl x509 -req -days 365 -in user2-local.csr -CA local.crt -CAkey local.key -set_serial 02 -out user2-local.crt
  .openssl pkcs12 -export -out user2-local.pfx -inkey user2-local.key -in user2-local.crt -certfile local.crt
  .import cert pfs into browser

  ### configure jwilder/nginx-proxy container for server cert
  .see example docker-compose.yml for configuring jwilder/nginx-proxy, change cert dir
  .see example my_proxy for configuring jwilder/nginx-proxy, change cert dir
  .make sure you have a dhparam.pem or jwilder/nginx-proxy will auto generate on startup
