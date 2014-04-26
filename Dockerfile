###### Helixdns images
# A docker image that includes
# - etcd
# - helixdns
FROM qnib/fd20
MAINTAINER "Christian Kniep <christian@qnib.org>"

## supervisord
RUN yum install -y supervisor 
RUN mkdir -p /var/log/supervisor
RUN sed -i -e 's/nodaemon=false/nodaemon=true/' /etc/supervisord.conf
ADD root/bin/supervisor_daemonize.sh /root/bin/supervisor_daemonize.sh

### ETCD INST BELOW
ADD yum-cache/qnib-etcd-0.3.0-20140423.2.x86_64.rpm /tmp/
RUN yum install -y /tmp/qnib-etcd-0.3.0-20140423.2.x86_64.rpm
RUN rm -f /tmp/qnib-etcd-0.3.0-20140423.2.x86_64.rpm
ADD etc/supervisord.d/etcd.ini /etc/supervisord.d/etcd.ini

### HELIXDNS INST BELOW
ADD yum-cache/qnib-helixdns-1.0.1-20140424.1.x86_64.rpm /tmp/
RUN yum install -y /tmp/qnib-helixdns-1.0.1-20140424.1.x86_64.rpm
RUN rm -f /tmp/qnib-helixdns-1.0.1-20140424.1.x86_64.rpm
ADD etc/supervisord.d/helixdns.ini /etc/supervisord.d/helixdns.ini

RUN yum install -y bind-utils 

CMD /bin/supervisord -c /etc/supervisord.conf
