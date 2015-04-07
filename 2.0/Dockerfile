FROM java:7u75
MAINTAINER kakawait <thibaud.lepretre@gmail.com>

### Install dependencies ###
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
  apt-get -yq install pwgen supervisor gettext-base sudo && \
  rm -rf /var/lib/apt/lists/*

### Install nuodb ###
# Fix http://dev.nuodb.com/community/news-announcements/critical-licensing-issue by using 2.0.4.24 build
RUN wget -q -O /tmp/nuodb_2.0.4.24_amd64.deb "http://download.nuohub.org/nuodb_2.0.4.24_amd64.deb" && \
    dpkg --install /tmp/nuodb_2.0.4.24_amd64.deb && \
    rm /tmp/nuodb_2.0.4.24_amd64.deb

### Setup ###
# Mount volume
RUN mkdir -p /opt/nuodb/data && \
    mkdir -p /nuodb-override && \
    chown nuodb:nuodb /opt/nuodb/data
VOLUME ["/opt/nuodb/data", "/nuodb-override"]
RUN chown nuodb:nuodb /opt/nuodb/data

# Add files
ADD run.sh /run.sh
ADD default.properties.tpl /opt/nuodb/etc/default.properties.tpl
RUN chmod +x /run.sh
ADD supervisord.conf.tpl /etc/supervisor/conf.d/supervisord.conf.tpl

### Environment variables ###
ENV NUODB_HOME /opt/nuodb
ENV BROKER true
ENV DOMAIN_USER domain
ENV DOMAIN_PASSWORD bird
ENV DBA_USER dba
ENV DBA_PASSWORD bird

ENV NEW_PROCESS_PORT_RANGE 48005

ENV DATABASE_NAME testdb

ENV AUTOMATION false
ENV AUTOMATION_BOOTSTRAP false

ENV LOG_LEVEL INFO

ENV NUOAGENT true
ENV NUOWEBCONSOLE true
ENV NUORESTSVC true

# Define working directory.
WORKDIR /opt/nuodb

CMD /run.sh 

# Broker
EXPOSE 48004
EXPOSE 48005
EXPOSE 48006

