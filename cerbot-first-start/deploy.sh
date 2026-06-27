#!/bin/bash
set -euo pipefail

# Vždy pracuj v adresáři tohoto skriptu, ať je volaný odkudkoliv
cd "$(dirname "${BASH_SOURCE[0]}")"

usage() {
    echo "Použití: $0 {start|stop|restart|status|log} [služba]"
    echo
    echo "  start            spustí celý stack (docker compose up -d)"
    echo "  stop             zastaví celý stack (docker compose down)"
    echo "  restart [služba] restartuje stack nebo jen vybranou službu"
    echo "  status           zobrazí stav kontejnerů (docker compose ps)"
    echo "  log [služba]     sleduje logy celého stacku nebo vybrané služby"
    exit 1
}

[ $# -ge 1 ] || usage

cmd="$1"
service="${2:-}"

case "$cmd" in
    start)
        docker compose up -d
        ;;
    stop)
        docker compose down
        ;;
    restart)
        docker compose restart $service
        ;;
    status)
        docker compose ps
        ;;
    log)
        docker compose logs -f $service
        ;;
    *)
        usage
        ;;
esac
