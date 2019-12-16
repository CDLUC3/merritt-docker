FROM solr:8.1
EXPOSE 8983 8983

COPY *.xml /tmp/
COPY *.sh /tmp/

ENTRYPOINT bash -c "precreate-core geoblacklight && source /tmp/mysetup.sh && solr-foreground"
