#!/bin/bash

set -x
echo 1 2 3 4 | xargs -I numbers echo "[numbers]"
