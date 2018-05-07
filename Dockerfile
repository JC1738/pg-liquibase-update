FROM openjdk:8-jdk

MAINTAINER Tom Beresford

# Create dirs
RUN mkdir -p /opt/liquibase &&\
  mkdir -p /opt/jdbc_drivers &&\
  mkdir /scripts

# Add volume
VOLUME ["/changelogs"]

# Add user
RUN useradd -ms /bin/bash duser

# Add liquibase
ADD http://repo1.maven.org/maven2/org/liquibase/liquibase-core/3.4.2/liquibase-core-3.4.2-bin.tar.gz /opt/liquibase/liquibase-core-3.4.2-bin.tar.gz
WORKDIR /opt/liquibase
RUN tar -xzf liquibase-core-3.4.2-bin.tar.gz &&\
  rm liquibase-core-3.4.2-bin.tar.gz &&\
  chmod +x /opt/liquibase/liquibase &&\
  ln -s /opt/liquibase/liquibase /usr/local/bin/

WORKDIR /

# Add postgres driver
ADD ./dev_support/liquibase/postgresql-42.1.4.jar opt/jdbc_drivers/postgresql-42.1.4.jar
RUN chmod 644 /opt/jdbc_drivers/postgresql-42.1.4.jar

# Add update script
COPY update.sh /scripts/
RUN chmod +x /scripts/update.sh

# Prepare for running container
WORKDIR /home/duser
USER duser
CMD ["/scripts/update.sh"]
