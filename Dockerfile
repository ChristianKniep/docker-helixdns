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

### ETCD INST BELOW
ADD etc/supervisord.d/etcd.ini /etc/supervisord.d/etcd.ini

### HELIXDNS INST BELOW
ADD etc/supervisord.d/helixdns.ini /etc/supervisord.d/helixdns.ini

CMD /bin/supervisord -c /etc/supervisord.conf
