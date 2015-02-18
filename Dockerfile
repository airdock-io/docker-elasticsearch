# VERSION 1.0
# AUTHOR:         Jerome Guibert <jguibert@gmail.com>
# DESCRIPTION:    ElasticSearch 
# TO_BUILD:       docker build --rm -t airdock/elasticsearch .
# SOURCE:         https://github.com/airdock-io/docker-elasticsearch

# Pull base image.
FROM airdock/oracle-jdk:1.8
MAINTAINER Jerome Guibert <jguibert@gmail.com>

ENV ELASTICSEARCH_VERSION 1.4.3

ENV ES_USER elasticsearch
ENV ES_GROUP elasticsearch
ENV ES_HOME /usr/share/elasticsearch
ENV CONF_FILE /etc/elasticsearch/elasticsearch.yml

ENV ELASTICSEARCH_CLUSTER_NAME elasticsearch
ENV ELASTICSEARCH_NODE_MASTER true
ENV ELASTICSEARCH_NODE_DATA true
ENV ELASTICSEARCH_INDEX_NUMBER_SHARDS 5
ENV ELASTICSEARCH_INDEX_NUMBER_REPLICAS 1
ENV ELASTICSEARCH_TRANSPORT_TCP_PORT 9300
ENV ELASTICSEARCH_TRANSPORT_TCP_COMPRESS false
ENV ELASTICSEARCH_HTTP_PORT 9200
ENV ELASTICSEARCH_HTTP_JSONP_ENABLE false

# Add configuration file
ADD config/*.yml /tmp/

ENV DEBIAN_FRONTEND noninteractive

# add gpg key for elasticsearch
# install elasticsearch and obz/elasticsearch-head plugin
RUN curl https://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add - && \
	echo 'deb http://packages.elasticsearch.org/elasticsearch/1.4/debian stable main' > /etc/apt/sources.list.d/elasticsearch.list && \
	apt-get update -qq && \
	apt-get install -y elasticsearch=$ELASTICSEARCH_VERSION && \
	rm /etc/elasticsearch/*.yml && \
	mv /tmp/*.yml /etc/elasticsearch && \
    mkdir -p /var/lib/elasticsearch/data  /usr/share/elasticsearch/plugins && \
    chown -R "$ES_USER":"$ES_GROUP" /var/log/elasticsearch /var/lib/elasticsearch && \
	$ES_HOME/bin/plugin -install mobz/elasticsearch-head && \	
	apt-get clean -qq && \
	rm -rf /var/lib/apt/lists/* /var/lib/apt/lists/* /tmp/* /var/tmp/* 


# Define working directory.
WORKDIR /var/lib/elasticsearch/data

# Mountable data directories.
VOLUME ["/var/lib/elasticsearch/data"]

# Mountable log directory.
VOLUME ["/var/log/elasticsearch"]

# Expose HTTP port
EXPOSE 9200
# Expose transport port
EXPOSE 9300

# Define default command.
CMD ["gosu", "elasticsearch:elasticsearch", "/usr/share/elasticsearch/bin/elasticsearch", "--default.config" ,"/etc/elasticsearch/elasticsearch.yml"]




