FROM docker.elastic.co/beats/filebeat:7.17.0
 
USER root
COPY filebeat.yml /usr/share/filebeat/filebeat.yml
RUN chown -R root /usr/share/filebeat/filebeat.yml
RUN chmod -R go-w /usr/share/filebeat/filebeat.yml
