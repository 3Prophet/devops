#!/usr/bin/env bash
# Old metadata clean up
yum clean all
# Epel story : https://community.nethserver.org/t/cannot-retrieve-metalink-for-repository-epel-x86-64/7061/23
yum --disablerepo=“epel” update nss -y
yum remove epel-release --disablerepo=epel -y
yum -y upgrade ca-certificates
yum -y upgrade ca-certificates --disablerepo=epel

yum update -y


yum install wget -y

yum install git -y
git config --global core.autocrlf input

INSTALL_DIR="/opt"
DISTRO="/vagrant/software"
PROFILE="/etc/profile.d/jdk8.sh"
TEMP_DIR="/home/vagrant/temp_mysql"

FJDK_ARCH="jdk-8u201-linux-x64.tar.gz"
JDK="jdk1.8.0_201"

mkdir $TEMP_DIR
cd $TEMP_DIR

# Installing Java 8

cp $DISTRO/$FJDK_ARCH $TEMP_DIR
tar xzvf $FJDK_ARCH

mv $JDK $INSTALL_DIR
touch $PROFILE

echo "export JAVA_HOME=${INSTALL_DIR}/${JDK}" >> $PROFILE
echo "export PATH=${JAVA_HOME}/bin:$PATH" >> $PROFILE
echo "export JRE_HOME=${JAVA_HOME}/jvm/jre" >> $PROFILE
source $PROFILE

#Installing epel repositories for MYSQL WORKBENCH
yum install epel-release -y

# Installing MYSQL DBMS
wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
rpm -ivh mysql-community-release-el7-5.noarch.rpm
yum install mysql-server -y
systemctl start mysqld
echo  "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('ROOTPASSWORD');" | mysql -u root
if [ ! -f /var/log/dbinstalled ];
then
    echo "CREATE USER 'vagrant'@'localhost' IDENTIFIED BY 'vagrant'" | mysql -uroot -pROOTPASSWORD
    echo "CREATE USER 'vagrant'@'%' IDENTIFIED BY 'vagrant'" | mysql -uroot -pROOTPASSWORD
    echo "CREATE DATABASE sonarqube_db" | mysql -uroot -pROOTPASSWORD
    echo "GRANT ALL ON *.* TO 'vagrant'@'localhost'" | mysql -uroot -pROOTPASSWORD
    echo "GRANT ALL ON *.* TO 'vagrant'@'%'" | mysql -uroot -pROOTPASSWORD
    echo "flush privileges" | mysql -uroot -pROOTPASSWORD
    sudo touch /var/log/dbinstalled
fi

# Installing  MYSQL WORKBENCH
yum install mysql-workbench -y


yum install maven -y

curl -sL https://rpm.nodesource.com/setup_10.x | sudo -E bash -
yum install nodejs -y
npm install -g @angular/cli -N

curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

curl -L https://github.com/docker/machine/releases/download/v0.16.1/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine &&
chmod +x /tmp/docker-machine &&
sudo cp /tmp/docker-machine /usr/local/bin/docker-machine

curl -L https://github.com/docker/compose/releases/download/1.25.0-rc1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
cp /vagrant/software/vscode.repo /etc/yum.repos.d
sudo yum install code -y

# To start/stop docker service type:
# sudo service docker start

#For installing missing proect modules
npm install -g npm-install-missing

# Within your project directory: npm-install-missing


wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm

sudo yum localinstall google-chrome-stable_current_x86_64.rpm -y
