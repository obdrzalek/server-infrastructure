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

# instalace dockeru
```bash
sudo apt update
sudo apt install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker tomas
```


# instalace server-infrastructure
* `sudo apt install docker`
* `git clone git@github.com:obdrzalek/server-infrastructure.git`
* `chmod -x deploy.sh`

# cerbot
* při prvním spuštění
```bash
cp variants/nginx-without-ssl.conf nginx.conf
./deploy.sh start
./deploy.sh stop
cp variants/nginx-test.eduis.conf nginx.conf
```