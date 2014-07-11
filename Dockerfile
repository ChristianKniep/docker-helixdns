###### Helixdns images
# A docker image that includes
# - etcd
# - helixdns
FROM qnib/etcd
MAINTAINER "Christian Kniep <christian@qnib.org>"

### HELIXDNS INST BELOW
ADD yum-cache/bullx-helixdns-1.0.1-20140704.1.x86_64.rpm /tmp/
RUN yum install -y /tmp/bullx-helixdns-1.0.1-20140704.1.x86_64.rpm
RUN rm -f /tmp/bullx-helixdns-1.0.1-20140704.1.x86_64.rpm

RUN yum install -y bind-utils python-dns python-pydns

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

# python-etcd
ADD yum-cache/pyetcd/ /tmp/yum-cache/pyetcd/
RUN yum install -y /tmp/yum-cache/pyetcd/python-cryptography-0.2.2-1.x86_64.rpm
RUN yum install -y /tmp/yum-cache/pyetcd/python-pyopenssl-0.13.1-1.x86_64.rpm
RUN yum install -y python-urllib3-1.7-4.fc20.noarch
RUN yum install -y python-requests
RUN yum install -y /tmp/yum-cache/pyetcd/python-etcd-0.3.0-1.noarch.rpm
RUN rm -rf /tmp/yum-cache/pyetcd

## Setup with delay of 5 sec
ADD etc/supervisord.d/setup.ini /etc/supervisord.d/setup.ini
ADD root/bin/setup.sh /root/bin/setup.sh

CMD /bin/supervisord -c /etc/supervisord.conf
