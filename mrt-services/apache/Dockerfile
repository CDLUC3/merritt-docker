FROM httpd

RUN sed -i '/LoadModule rewrite_module/s/^#//g' /usr/local/apache2/conf/httpd.conf
RUN echo "Include conf/conf.d/*.conf" >> /usr/local/apache2/conf/httpd.conf

RUN mkdir /usr/local/apache2/conf/conf.d
COPY mrt.conf /usr/local/apache2/conf/conf.d
