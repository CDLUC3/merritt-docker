FROM httpd:2.4
RUN apt-get update -y -qq && apt-get install -y build-essential curl vim ruby

COPY mrt.conf /usr/local/apache2/conf/conf.d/mrt.conf
RUN mkdir /usr/local/apache2/redirect
COPY customEncode.rb /usr/local/apache2/redirect/
RUN chmod +x /usr/local/apache2/redirect/customEncode.rb

EXPOSE 8099

RUN sed -i \
        -e 's/^#\(LoadModule .*mod_rewrite.so\)/\1/' \
        -e 's/^#\(LoadModule .*mod_proxy.so\)/\1/' \
        -e 's/^#\(LoadModule .*mod_proxy_ajp.so\)/\1/' \
        -e 's/^#\(LoadModule .*mod_proxy_balancer.so\)/\1/' \
        -e 's/^#\(LoadModule .*mod_proxy_connect.so\)/\1/' \
        -e 's/^#\(LoadModule .*mod_proxy_express.so\)/\1/' \
        -e 's/^#\(LoadModule .*mod_proxy_fcgi.so\)/\1/' \
        -e 's/^#\(LoadModule .*mod_proxy_fdpass.so\)/\1/' \
        -e 's/^#\(LoadModule .*mod_proxy_ftp.so\)/\1/' \
        -e 's/^#\(LoadModule .*mod_proxy_http.so\)/\1/' \
        -e 's/^#\(LoadModule .*mod_proxy_hcheck.so\)/\1/' \
        -e 's/^#\(LoadModule .*mod_proxy_scgi.so\)/\1/' \
        -e 's/^#\(LoadModule .*mod_proxy_uwsgi.so\)/\1/' \
        -e 's/^#\(LoadModule .*mod_proxy_wstunnel.so\)/\1/' \
        -e 's/^#\(LoadModule .*mod_dumpio.so\)/\1/' \
        -e 's/^#\(LoadModule .*mod_slotmem_shm.so\)/\1/' \
        -e 's/^#\(LoadModule .*mod_lbmethod_byrequests.so\)/\1/' \
        -e 's/^#\(LoadModule .*mod_lbmethod_bybusyness.so\)/\1/' \
        -e 's/^#\(LoadModule .*mod_lbmethod_heartbeat.so\)/\1/' \
        -e 's/^#\(LoadModule .*mod_lbmethod_bytraffic.so\)/\1/' \
        -e 's/^#\(LoadModule .*mod_watchdog.so\)/\1/' \
        conf/httpd.conf

RUN echo "Include conf/conf.d/*.conf" >> /usr/local/apache2/conf/httpd.conf

