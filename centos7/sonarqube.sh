#!/usr/bin/env bash

sudo yum update -y
sudo yum upgrade -y
sudo yum install wget unzip -y
sudo yum install yum install java-1.8.0-openjdk-devel.x86_64 -y
sudo echo -e "export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk" >> /etc/profile
sudo echo -e "export JRE_HOME=/usr/lib/jvm/jre" >> /etc/profile
sudo source /etc/profile
sudo wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
sudo rpm -ivh mysql-community-release-el7-5.noarch.rpm
sudo yum install mysql-server -y
sudo systemctl start mysqld
sudo echo  "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('ROOTPASSWORD');" | mysql -u root
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
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-7.5.zip
sudo unzip sonarqube-7.5.zip
sudo mv sonarqube-7.5 /opt/sonarqube
sudo chown vagrant:vagrant /opt/sonarqube -R

sudo echo -e "sonar.jdbc.username=vagrant" >> /opt/sonarqube/conf/sonar.properties
sudo echo -e "sonar.jdbc.password=vagrant" >> /opt/sonarqube/conf/sonar.properties
sudo echo -e "sonar.jdbc.url=jdbc:mysql://localhost:3306/sonarqube_db?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true&useConfigs=maxPerformance" >> /opt/sonarqube/conf/sonar.properties

sudo sed -i '/#RUN_AS_USER=/c RUN_AS_USER=vagrant' /opt/sonarqube/bin/linux-x86-64/sonar.sh

sudo touch /etc/systemd/system/sonar.service

sudo echo -e "[Unit]" >> /etc/systemd/system/sonar.service
sudo echo -e "Description=SonarQube" >> /etc/systemd/system/sonar.service
sudo echo -e "After=syslog.target network.target" >> /etc/systemd/system/sonar.service

sudo echo -e "[Service]" >> /etc/systemd/system/sonar.service
sudo echo -e "Type=forking" >> /etc/systemd/system/sonar.service

sudo echo -e "ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh" start >> /etc/systemd/system/sonar.service
sudo echo -e "ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh" stop >> /etc/systemd/system/sonar.service

sudo echo -e "User=vagrant" >> /etc/systemd/system/sonar.service
sudo echo -e "Group=vagrant" >> /etc/systemd/system/sonar.service
sudo echo -e "Restart=always" >> /etc/systemd/system/sonar.service

sudo echo -e "[Install]" >> /etc/systemd/system/sonar.service
sudo echo -e "WantedBy=multi-user.target" >> /etc/systemd/system/sonar.service

sudo systemctl enable sonar.service
sudo systemctl start sonar.service

echo "Access sonarqube on the following address: http://your_ip_address:9000"
echo "Default administrator username and password are: admin"