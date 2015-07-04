# ElasticSearch

Docker Image for [elasticsearch](http://www.elasticsearch.com/) based on airdock/oracle-jdk:1.8 (latest)


Purpose of this image is:

- install elasticsearch server
- based on airdock/oracle-jdk:1.8 (debian)

> Name: airdock/elasticsearch

***Dependency***: airdock/oracle-jdk:latest

***Few links***:

- [Docker Elasticsearch](https://github.com/dockerfile/elasticsearch)
- [Puckel Elasticsearch](https://github.com/puckel/dockerfiles)
- [Installation ES](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/setup-repositories.html)
- [Configuration](http://elasticsearch.org/guide/en/elasticsearch/reference/current/setup-configuration.html)



# Usage


Execute elastic server with default configuration:

	'docker run -d -p 9200:9200 -p 9300:9300 --name elasticsearch airdock/elasticsearch '

## With a persistent storage

	'docker run -d -p 9200:9200 -p 9300:9300 -v /var/lib/elasticsearch:/var/lib/elasticsearch --name elasticsearch airdock/elasticsearch'

Take care about your permission on host folder named '/var/lib/elasticsearch'.

The user elasticsearch (uid 4202) in your container should be known into your host.
See :
* [How Managing user in docker container ?](https://github.com/airdock-io/docker-base/wiki/How-Managing-user-in-docker-container)
* [Common User List](https://github.com/airdock-io/docker-base/wiki/Common-User-List)

So you should create an user with this uid:gid:

```
  sudo groupadd elasticsearch -g 4202
  sudo useradd -u 4202  --no-create-home --system --no-user-group elasticsearch
  sudo usermod -g elasticsearch elasticsearch
```

And then set owner and permissions on your host directory:

```
	chown -R elasticsearch:elasticsearch /var/lib/elasticsearch
```

Don't forget to add your current user to this new group.



## Elasticsearch Configuration

```
	# common settings
	cluster.name: elasticsearch
	node.master: true
	node.data: true
	index.number_of_shards: 5
	index.number_of_replicas: 1
	transport.tcp.port: 9300
	transport.tcp.compress: false
	http.port: 9200
	http.jsonp.enable: false

	#Kibana 3 and Elasticsearch 1.4 - CORS problem
	http.cors.enabled: true
	http.cors.allow-origin: "*"


	path.conf: /etc/elasticsearch
	path.data: /var/lib/elasticsearch
	path.work: /tmp/elasticsearch
	path.logs: /var/logs/elasticsearch
	path.plugins: /usr/share/elasticsearch/plugins
```

## Notes

- Configuration path: /etc/elasticsearch
- Data path: /var/lib/elasticsearch
- Log path: /var/logs/elasticsearch
- Plugins installation path: /usr/share/elasticsearch/plugins

# Change Log


## latest (current)

- install elasticsearch
- define ELASTICSEARCH_VERSION (1.4.3)
- add volume on data folder (/var/lib/elasticsearch) and log folder
- default log ouput to console
- expose 9200 (http) and 9300 (transport) port
- default configuration is a master with node storage capability
- add plugin mobz/elasticsearch-head
- launch elasticsearch with elasticsearch user
- MIT license

# Build

- Install "make" utility, and execute: `make build`
- Or execute: 'docker build -t airdock/elasticsearch:latest --rm .'

See [Docker Project Tree](https://github.com/airdock-io/docker-base/wiki/Docker-Project-Tree) for more details.


# MIT License

```
The MIT License (MIT)

Copyright (c) 2015 Airdock.io

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
