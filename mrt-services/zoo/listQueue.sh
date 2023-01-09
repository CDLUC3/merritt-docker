#!/bin/sh
#*********************************************************************
#   Copyright 2019 Regents of the University of California
#   All rights reserved
#*********************************************************************
export CP=/$ZK/zkServer/tools/cdl-zk-queue-0.2-SNAPSHOT.jar
CP=$CP:/$ZK/zkServer/tools/mrt-zoopub-src-1.0-SNAPSHOT.jar
CP=$CP:/$ZK/zkServer/tools/mrt-core-2.0-SNAPSHOT.jar
# Find log4j
CP=$CP:/$ZK/zkServer/tools

L4J=1.2.17
S4J=1.7.25

CP=$CP:/$ZK/lib/$ZKJ.jar
CP=$CP:/$ZK/lib/$ZKJUTE.jar
CP=$CP:/$ZK/lib/slf4j-log4j12-$S4J.jar
CP=$CP:/$ZK/lib/log4j-$L4J.jar
CP=$CP:/$ZK/lib/slf4j-api-$S4J.jar

echo $CP

#Usage: listQueue.sh /ingest|/mrt.inventory.full

queue=${1:-/ingest}

#echo "java -cp $CP org.cdlib.mrt.queue.DistributedQueue $queue list"

java -cp $CP org.cdlib.mrt.queue.DistributedQueue $queue list
