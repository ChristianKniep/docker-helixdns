###### Helixdns images
# A docker image that includes
# - etcd
# - helixdns
FROM qnib/fd20
MAINTAINER "Christian Kniep <christian@qnib.org>"

# Solution for 'ping: icmp open socket: Operation not permitted'
RUN chmod u+s /usr/bin/ping
RUN ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime

# Set (very simple) password for root
RUN echo "root:root"|chpasswd

### ENV BELOW

## supervisord
RUN yum install -y supervisor 
RUN mkdir -p /var/log/supervisor
RUN sed -i -e 's/nodaemon=false/nodaemon=true/' /etc/supervisord.conf

## etcd
ADD yum-cache/qnib-etcd-0.3.0-20140423.2.x86_64.rpm /tmp/
RUN yum install -y /tmp/qnib-etcd-0.3.0-20140423.2.x86_64.rpm
RUN rm -f /tmp/qnib-etcd-0.3.0-20140423.2.x86_64.rpm
ADD etc/supervisord.d/etcd.ini /etc/supervisord.d/etcd.ini

## helicdns
ADD yum-cache/qnib-helixdns-1.0.0-20140423.2.x86_64.rpm /tmp/
RUN yum install -y /tmp/qnib-helixdns-1.0.0-20140423.2.x86_64.rpm
RUN rm -f /tmp/qnib-helixdns-1.0.0-20140423.2.x86_64.rpm

CMD /bin/supervisord -c /etc/supervisord.conf
