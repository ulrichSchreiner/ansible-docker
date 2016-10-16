#!/bin/sh

docker build -t ulrichschreiner/ansible .
docker build -t ulrichschreiner/ansible:`git describe` .
