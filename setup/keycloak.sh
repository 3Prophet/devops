#!/usr/bin/env bash
#sudo docker network create keycloak-network
#sudo docker run --name mysql -d --net keycloak-network -e DB_DATABASE=keycloak -e DB_USER=keycloak -e DB_PASSWORD=password -e DB_ROOT_PASSWORD=root_password mysql
#sudo docker run --name keycloak -d --net keycloak-network -p 8080:8080 -e DB_USER=keycloak -e DB_PASSWORD=password jboss/keycloak
#sudo docker exec keycloak keycloak/bin/add-user-keycloak.sh -u keycloak -p keycloak
#sudo docker restart keycloak


sudo docker start mysql
sudo docker start keycloak