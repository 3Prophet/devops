#!/usr/bin/env bash

sudo yum update -y
sudo yum upgrade -y
sudo yum install wget unzip -y
sudo yum install yum install java-1.8.0-openjdk-devel.x86_64 -y
sudo echo -e "export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk" >> /etc/profile
sudo echo -e "export JRE_HOME=/usr/lib/jvm/jre" >> /etc/profile
sudo source /etc/profile

sudo yum install git -y
mkdir /opt/gerrit
#sudo adduser --system --no-create-home --group --disabled-login sonarqube
#sudo adduser gerrit
#sudo chown -R gerrit:gerrit /opt/gerrit
sudo wget https://gerrit-releases.storage.googleapis.com/gerrit-2.16.3.war
sudo mv gerrit-2.16.3.war /opt/gerrit/gerrit-2.16.3.war
#sudo su gerrit
sudo mkdir /opt/gerrit/gerrit_testsite
sudo java -jar /opt/gerrit/gerrit-2.16.3.war init --batch --dev -d opt/gerrit/gerrit_testsite
sudo git config --file gerrit_testsite/etc/gerrit.config httpd.listenUrl 'http://localhost:8080'




