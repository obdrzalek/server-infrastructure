#!/usr/bin/env bash
set -euo pipefail

~/server-infrastructure/nginx/deploy.sh stop
~/eduis/infrastructure/test/deploy.sh stop
~/server-infrastructure/infra/deploy.sh stop
