# Infrastruktura serveru
* projekt obsahuje společné dockery pro vytvoření serverového prostředí
* `create-certificate` - vytvoří certifikáty pro jednotlivé domény a ulož je do složky `certbot`
* `infra` - základní infrastruktura pro všechny aplikace 
  * postgresl
  * network `server`
  * spouští se jako první
* `nginx` - proxy server pro všechny aplikace
  * porty 80 a 443
  * načítá certifikáty ze složky `~/cerbots`
  * `certbot` - obnoví certifikáty, jeli-to třeba
  * spouští se jako poslední

## Vygenerování certifikátů
*  `~/server-infrastructure/create-certificate/create-cerificate.sh`
* certifikáty se uloží do `~/cerbots`

## Secrets
* složka `~/secrets`
* `test` - `DB_PASSWORD`, `MAIL`
* `prod` - `DB_PASSWORD`, `MAIL`
* `postgresql` - `POSTGRES_PASSWORD` - hlavní heslo

## Postgres data
* složka `~/postgres-data`

## Spuštění
* postupně tři `docker-compose`
  1. `~/server-infrastructure/infra/deploy.sh start` (postgres, network `server`)
  1. `~/eduis/infrastructure/test|prod/deploy.sh start` (frontend, backend)
  1. `~/server-infrastructure/nginx/deploy.sh start` (proxy server, cerbot)
* nebo najednou `all-deploy.sh`, `all-stop.sh`, `all-redeploy.sh`

## Konfigurace nginx
* složka `variants` obsahuje `nginx.conf` pro jednotlivé varianty
* vytvořit link: `cd ~/server-infrastructure/nginx & ln -s variats/nginx-test.eduis.conf nginx.conf`
* `nginx.conf` je vyjmut z gitu