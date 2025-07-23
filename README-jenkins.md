# Jenkins set-up

## Set-up Jenkins server

You need a dedicated server to run Jenkins (with an http access on the port 8080). You can use an AWS EC2 (warning it have to be powerful to run the build):

Specs:

- Ubuntu t3.large ;
- AMI: ami-02003f9f0fde924ea ;
- Security group with ssh access / web access / web access on 8080 port ;
- PEM (access key to connect to ssh) ;

You can try on your own risks with something smaller :)

## Install deps

### Install JAVA 21 (required)

Update system (ubuntu)

```
sudo apt update
sudo apt upgrade -y
```

Install JAVA

```
sudo apt install -y openjdk-21-jdk
java -version  # Validate that JAVA is installed with the 21 version
```

### Install Maven (required for the build)

```
sudo apt update
sudo apt install -y maven
```

Check if the operation was successful:

```
mvn -version
```

### Install Postgresql as Service (required for the build)

```
sudo apt install -y postgresql
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

### Alter Postgresql Postgres user informations

Because the build need the database up and running with some specifics informations, you have to set manually that informations properly in Postgresql.

1. Validate tha Postgresql run as service

```
sudo systemctl status postgresql
```

2. Connect to the database to change user postgres password

```
sudo -u postgres psql
```

3. Change password

```
ALTER USER postgres WITH PASSWORD 'postgres';
```

4. Test the connection

```
PGPASSWORD=postgres psql -h localhost -U postgres -d postgres -c "\conninfo"
```

If everthing is ok good... if not you have to solve that problem before going to the next steps.

### Install Jenkins as Service

```
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install -y jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins
```

When Jenkins is installed you can start the configuration in the UI interface.

Get the initial admin password here:
```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Use the initial admin password to login

```
http://<IP_EC2>:8080
```

Set the default informations for the user

```
Username: admin
Password: admin
Name: fginioux
Email: frederic.ginioux@hotmail.fr
```

Before starting the first pipeline you have to set some pre-required tasks...

#### Install Jenkins plugins

Select the default set of recommanded plugins. In addition you have to install:

- SSH Agent Plugin ;
- Git Plugin (should be part of the community list) ;
- Maven Integration Plugin ;

Restart jenkins service:

```
sudo systemctl restart jenkins
```

You have also to define secrets informations (global settings):

- GITHUB_TOKEN_CRED_ID <Personnal access token for the GITHUB repository access>
- SERVER_IP_CRED_ID <IP of the deployed api server / see api server section>
- aws-ec2 <AWS RSA PEM KEY PAIRS / copy past that value in a username/ssh secret with the username: ubuntu (should be the user that connect to the EC2)>

You can create the first pipeline "the-bill-pipeline" and register variables:

- GITHUB_URL: https://github.com/fginioux/the-bill-please (use in the checkout) ;
- GITHUB_USER: fginioux (not used)

You can register now the configuration of the jenkins file (available in the repo.)

