#!/usr/bin/env bash

sudo yum update -y
sudo yum upgrade -y
sudo yum install wget unzip -y
sudo yum install yum install java-1.8.0-openjdk-devel.x86_64 -y
sudo echo -e "export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk" >> /etc/profile
sudo echo -e "export JRE_HOME=/usr/lib/jvm/jre" >> /etc/profile
sudo source /etc/profile
sudo wget https://bintray.com/jfrog/artifactory-rpms/rpm -O bintray-jfrog-artifactory-rpms.repo
sudo mv bintray-jfrog-artifactory-rpms.repo /etc/yum.repos.d
sudo yum install jfrog-artifactory-oss.noarch -y
sudo service artifactory start
sudo echo "Artifactory is running under: hostname:8081/artifactory"
#sudo /opt/jfrog/artifactory/bin/artifactoryManage.sh start

