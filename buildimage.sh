#!/bin/bash

docker rmi --force eborges/php7.2-cli:latest
docker build -t eborges/php7.2-cli .
