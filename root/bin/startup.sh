#!/bin/bash

echo "Set SRV record for _etcd._tcp"
/usr/local/bin/etcdctl set /helix/_tcp/_etcd/SRV '[{"Priority":10,"Weight":60,"Port":4001,"Target":"dns."}]'
/usr/local/bin/etcdctl set /helix/qnib/_tcp/_etcd/SRV '[{"Priority":10,"Weight":60,"Port":4001,"Target":"dns."}]'

sleep 2
exit 0
