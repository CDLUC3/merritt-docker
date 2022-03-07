Updates to default server.xml
=============================

I need to redirect tomcat access logs to stdout so they can be indexed into opensearch.

```
merritt-docker/mrt-services/store> docker exec -ti store cat /usr/local/tomcat/conf/server.xml > server.xml.dist
merritt-docker/mrt-services/store> cp server.xml server.xml.dist
vi server.xml
merritt-docker/mrt-services/store> merritt-docker/mrt-services/store> diff server.xml.dist server.xml
163,164c163,164
<         <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
<                prefix="localhost_access_log" suffix=".txt"
---
>         <Valve className="org.apache.catalina.valves.AccessLogValve" directory="/dev/stdout"
>                prefix="" suffix="" rotatable="false"
```

