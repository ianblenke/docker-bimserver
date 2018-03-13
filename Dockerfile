FROM tomcat:8.5-jre8

ARG BIMSERVER_VERSION
ENV BIMSERVER_VERSION ${BIMSERVER_VERSION}

ENV TOMCAT_HOME /usr/local/tomcat
ENV BIMSERVER_APP $TOMCAT_HOME/webapps/bimserver

# Delete the example Tomcat app to speed up deployment.
RUN rm -rf $TOMCAT_HOME/webapps/examples

ADD https://github.com/opensourceBIM/BIMserver/releases/download/parent-${BIMSERVER_VERSION}/bimserverwar-${BIMSERVER_VERSION}.war ${BIMSERVER_APP}.war
RUN unzip $BIMSERVER_APP.war -d $BIMSERVER_APP

ENV CATALINA_HOME=/usr/local/tomcat
ENV JAVA_OPTS="-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom"
ENV CATALINA_OPTS="-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

# Add roles and increase file size for webapps to 500Mb
ADD ./web.xml /usr/local/tomcat/webapps/manager/WEB-INF/web.xml
ADD ./run.sh /run.sh

EXPOSE 8080

CMD /run.sh
