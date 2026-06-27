#!/bin/bash
set -euo pipefail

# Email pro Let's Encrypt registraci.
CERTBOT_EMAIL="admin@eduis.cz"

# Vždy pracuj v adresáři tohoto skriptu, ať je volaný odkudkoliv
cd "$(dirname "${BASH_SOURCE[0]}")"

usage() {
    echo "Použití: $0"
    echo
    echo "  Skript spusti nginx, vytvori certifikaty,"
    echo "                   vypise existujici certifikaty a vse ukonci"
    echo "                   email nastav v promenne CERTBOT_EMAIL ve skriptu"
    exit 1
}

[ $# -eq 0 ] || usage

read_domains_from_shared_file() {
    local raw domains_line cleaned

    raw="$(grep -E '^[[:space:]]*server_name[[:space:]]+' domains.conf | head -n 1 || true)"
    if [ -z "$raw" ]; then
        echo "Nenalezen server_name v domains.conf"
        return 1
    fi

    cleaned="$(printf '%s' "$raw" | sed -E 's/#.*$//; s/^[[:space:]]*server_name[[:space:]]+//; s/;[[:space:]]*$//; s/,/ /g')"
    domains_line="$(printf '%s' "$cleaned" | xargs)"
    if [ -z "$domains_line" ]; then
        echo "V server_name nejsou zadne domeny"
        return 1
    fi

    printf '%s\n' "$domains_line"
}

domain_string="$(read_domains_from_shared_file)" || exit 1
read -r -a domains <<< "$domain_string"
if [ "${#domains[@]}" -eq 0 ]; then
    echo "Nacteni domen z domains.conf selhalo"
    exit 1
fi

domain_args=()
for domain in "${domains[@]}"; do
    domain_args+=("-d" "$domain")
done

certbot_email="$CERTBOT_EMAIL"
if [ -z "$certbot_email" ]; then
    echo "Chybi email. Nastav CERTBOT_EMAIL primo ve skriptu."
    exit 1
fi

cleanup() {
    docker compose down >/dev/null 2>&1 || true
}
trap cleanup EXIT

# Nginx musi bezet, aby HTTP-01 challenge byla dostupna na portu 80.
docker compose up -d nginx
echo "Vytvarim certifikaty pro domeny: ${domains[*]}"
docker compose run --rm --entrypoint certbot certbot \
    certonly --webroot -w /var/www/html \
    --force-renewal --agree-tos --no-eff-email \
    --email "$certbot_email" \
    "${domain_args[@]}"

echo
echo "Vytvorene certifikaty:"
docker compose run --rm --entrypoint certbot certbot certificates
