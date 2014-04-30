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

# etcdctl
ADD usr/local/bin/etcdctl /usr/local/bin/etcdctl

### configure stuff at startup
ADD root/bin/startup.sh /root/bin/
ADD etc/supervisord.d/startup.ini /etc/supervisord.d/

# setup
ADD root/bin/setup.sh /root/bin/
ADD root/dns.aliases root/dns.aliases
ADD etc/supervisord.d/setup.ini /etc/supervisord.d/setup.ini

# ipv6 messes up with me
RUN echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf

CMD /bin/supervisord -c /etc/supervisord.conf
