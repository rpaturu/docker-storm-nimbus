#!/bin/bash

set -eo pipefail

export HOST_IP=${HOST_IP:-172.17.8.101}
export ETCD=$HOST_IP:4001
export NIMBUS_HOST=$1

echo "[storm] booting container. ETCD: $ETCD"

sed -i "s/NIMBUS_HOST/$NIMBUS_HOST/" /etc/confd/templates/storm.yaml.tmpl

until confd -onetime -node $ETCD -config-file /etc/confd/conf.d/storm.toml > /var/log/confd.log 2>&1; do
  echo "[storm] waiting for confd to refresh storm.yaml"
  sleep 5
done

echo "[storm] running storm nimbus"
/usr/share/storm/bin/storm nimbus

# Wait for nimbus to start
sleep 30

echo "[storm] tailing all storm log files"
tail -f /usr/share/storm/logs/*

echo "[storm] Running confd in the background"
# Run confd in the background to watch the upstream servers
confd -interval 120 -node $ETCD -config-file /etc/confd/conf.d/storm.toml > /var/log/confd.log 2>&1
