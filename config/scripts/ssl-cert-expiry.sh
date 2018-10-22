#!/bin/bash
openssl x509 -in /etc/letsencrypt/live/domain/cert.pem -text -noout | sed -En 's/\s*Not After : (.*)GMT/\1/p'
