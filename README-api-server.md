# JAVA API Server

## Set-up server

Install a dedicated AWS Server to run the JAVA API. 

Specs:

- Ubuntu t3.micro ;
- AMI: ami-02003f9f0fde924ea ;
- Security group with ssh access / web access / web access on 8081 port ;
- PEM (access key to connect to ssh) ;

## Install deps to run the API

### Install Docker

```
sudo apt update
sudo apt install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
```

### Add current user to docker group

```
sudo usermod -aG docker $USER
```

Warning: you have to exit the session before been able to run docker commands without sudo ;

### Install Docker Compose

```
sudo apt install -y docker-compose-plugin
```

