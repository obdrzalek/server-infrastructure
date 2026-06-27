# Server infrastructure
* repozitář pro nasazení
  * nginx reverse proxy
  * postgresl
  * cerbot
  * případné další společné dockery

* používá společnou sít `server`
* jediná exportuje porty
  * https
  * postgresql

# instalace
* `git clone git@github.com:obdrzalek/server-infrastructure.git`
* `chmod -x deploy.sh`

