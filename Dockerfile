# VERSION 1.0
# AUTHOR:         Jerome Guibert <jguibert@gmail.com>
# DESCRIPTION:    ElasticSearch 
# TO_BUILD:       docker build --rm -t airdock/elasticsearch .
# SOURCE:         https://github.com/airdock-io/docker-elasticsearch

# Pull base image.
FROM airdock/oracle-jdk:latest
MAINTAINER Jerome Guibert <jguibert@gmail.com>

ENV ELASTICSEARCH_VERSION 1.4.3

# Define user
ENV ES_USER elasticsearch
# Define Home
ENV ES_HOME /usr/share/elasticsearch

# Add configuration file
ADD config/*.yml /tmp/


# add gpg key for elasticsearch
# install elasticsearch and obz/elasticsearch-head plugin
RUN curl https://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add - && \
	echo 'deb http://packages.elasticsearch.org/elasticsearch/1.4/debian stable main' > /etc/apt/sources.list.d/elasticsearch.list && \
	apt-get update -qq && \
	apt-get install -y elasticsearch=$ELASTICSEARCH_VERSION && \
	rm /etc/elasticsearch/*.yml && \
	mv /tmp/*.yml /etc/elasticsearch && \
    mkdir -p /var/lib/elasticsearch  $ES_HOME/plugins && \
    chown -R $ES_USER:$ES_USER /var/log/elasticsearch /var/lib/elasticsearch $ES_HOME/plugins && \
	$ES_HOME/bin/plugin -install mobz/elasticsearch-head && \
    /root/fix-user $ES_USER && \
	apt-get clean -qq && \
	rm -rf /var/lib/apt/lists/* /var/lib/apt/lists/* /tmp/* /var/tmp/* 

# Define working directory.
WORKDIR /var/lib/elasticsearch

# Mountable data directories.
VOLUME ["/var/lib/elasticsearch"]

# Mountable log directory.
VOLUME ["/var/log/elasticsearch"]

# Expose HTTP port
EXPOSE 9200
# Expose transport port
EXPOSE 9300

# Define default command.
CMD ["gosu", "elasticsearch:elasticsearch", "/usr/share/elasticsearch/bin/elasticsearch", "--default.config" ,"/etc/elasticsearch/elasticsearch.yml"]




