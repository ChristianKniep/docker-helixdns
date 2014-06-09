###### Helixdns images
# A docker image that includes
# - etcd
# - helixdns
FROM qnib/etcd
MAINTAINER "Christian Kniep <christian@qnib.org>"

### HELIXDNS INST BELOW
ADD yum-cache/qnib-helixdns-1.0.1-20140424.1.x86_64.rpm /tmp/
RUN yum install -y /tmp/qnib-helixdns-1.0.1-20140424.1.x86_64.rpm
RUN rm -f /tmp/qnib-helixdns-1.0.1-20140424.1.x86_64.rpm

RUN yum install -y bind-utils

# supervisord
ADD etc/supervisord.d/etcd.ini /etc/supervisord.d/etcd.ini
ADD etc/supervisord.d/helixdns.ini /etc/supervisord.d/helixdns.ini

# etcdctl
ADD usr/local/bin/etcdctl /usr/local/bin/etcdctl

### configure stuff at startup
ADD root/bin/startup.sh /root/bin/
ADD etc/supervisord.d/startup.ini /etc/supervisord.d/

# setup
ADD root/dns.aliases root/dns.aliases

## Setup with delay of 5 sec
ADD etc/supervisord.d/setup.ini /etc/supervisord.d/setup.ini
ADD root/bin/setup.sh /root/bin/setup.sh

CMD /bin/supervisord -c /etc/supervisord.conf
