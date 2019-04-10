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