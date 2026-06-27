#!/usr/bin/env bash
set -euo pipefail

~/server-infrastructure/infra/deploy.sh start
~/eduis/server-infrastructure/test/deploy.sh start
~/server-infrastructure/nginx/deploy.sh start
