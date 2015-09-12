#!/bin/bash

set -eo pipefail

echo "[storm] running storm nimbus"
/usr/share/storm/bin/storm ui
