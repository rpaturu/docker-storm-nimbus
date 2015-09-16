#!/bin/bash

set -eo pipefail

echo "[storm] stopping storm nimbus"
PID=(jps | grep core | cut -d " " -f 1)
kill -9 $PID

echo "[storm] starting storm ui"
/usr/share/storm/bin/storm ui
