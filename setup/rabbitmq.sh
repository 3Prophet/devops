#!/usr/bin/env bash

sudo docker container run -d -p 5672:5672 --hostname localhost --name rmq rabbitmq:3