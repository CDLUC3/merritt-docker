#!/bin/bash

if [[ "$REPLICA" != "true" ]]
then
  bin/dsconfig -h localhost -p 4444 -D "$ROOT_USER_DN" -X -n \
    -w "$ROOT_PASSWORD" \
    set-password-policy-prop \
    --policy-name "Default Password Policy" \
    --set "last-login-time-attribute:ds-pwp-last-login-time" \
    --set "last-login-time-format:yyyy-MM-dd HH:mm:ss"
fi
