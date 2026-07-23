FROM almalinux:9

ARG SES_PARMS=ses_passwd_not_set

RUN dnf -y update && \
    dnf -y install cyrus-sasl cyrus-sasl-plain cyrus-sasl-lib postfix s-nail && \
    dnf clean all

RUN /usr/sbin/postconf -e "relayhost = [email-smtp.us-west-2.amazonaws.com]:587" \
  "smtp_sasl_auth_enable = yes" "smtp_sasl_security_options = noanonymous" \
  "smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd" \
  "smtp_use_tls = yes" "smtp_tls_security_level = secure" \
  "smtp_tls_note_starttls_offer = yes" \
  'smtp_tls_CAfile = /etc/ssl/certs/ca-bundle.crt'

# Log directly to a file in-container and raise SMTP verbosity for troubleshooting.
RUN /usr/sbin/postconf -e "maillog_file = /var/log/maillog" \
  "smtp_tls_loglevel = 2" \
  "debug_peer_level = 3" \
  "debug_peer_list = email-smtp.us-west-2.amazonaws.com"

RUN echo "myhostname = merritt.cdlib.org" >> /etc/postfix/main.cf

RUN /usr/sbin/postconf -e "inet_interfaces = loopback-only" "inet_protocols = ipv4"

RUN echo "[email-smtp.us-west-2.amazonaws.com]:587 ${SES_PARMS}" > /etc/postfix/sasl_passwd

RUN /usr/sbin/postmap hash:/etc/postfix/sasl_passwd

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod 0755 /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]