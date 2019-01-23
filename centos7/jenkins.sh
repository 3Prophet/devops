#!/usr/bin/env bash

sudo yum update -y
sudo yum upgrade -y
sudo sudo yum install java-1.8.0-openjdk-devel -y
sudo curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install jenkins -y
sudo systemctl start jenkins
sudo systemctl enable jenkins