# Instalace

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

# git a nastavení
* `git clone git@github.com:obdrzalek/server-infrastructure.git`
* nastavení spustitelných souborů
  * `chmod +x ~/server-infrastructure/all*`
  * `chmod +x ~/server-infrastructure/nginx/deploy.sh`
  * `chmod +x ~/server-infrastructure/infra/deploy.sh`

