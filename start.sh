#!/bin/bash
service mysql start
service apache2 start

mkdir /var/cache/jetty9/data
cd /usr/share/jetty9; /usr/lib/jvm/java-8-openjdk-amd64/bin/java -Xmx256m -Djava.awt.headless=true 	-Djava.io.tmpdir=/var/cache/jetty9/data 	-Djava.library.path=/usr/lib 	-Djetty.home=/usr/share/jetty9 	-Djetty.logs=/var/log/jetty9 	-Djetty.state=/var/lib/jetty9/jetty.state -jar /usr/share/jetty9/start.jar jetty-started.xml    

#service jetty9 start
#while true; do sleep 10000; done
