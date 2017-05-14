#!/usr/bin/env bash

BASEPATH="/srv/docker-hackmd"
PROJECT="docker-compose.yml"
source $BASEPATH/back-tier.env
POSTGRES_DATABASE=$POSTGRES_USER
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")

function debug {
    echo "CONTAINER="$CONTAINER
    echo "HOST="$HOST
    echo "USER="$POSTGRES_USER
    echo "PASSWORD="$POSTGRES_PASSWORD
}

POSTGRES_CONTAINER=$(docker-compose -f $BASEPATH/$PROJECT ps postgres | grep postgres_[0-9] | awk "{ print \$1 }")
POSTGRES_HOST=$(docker ps | grep $POSTGRES_CONTAINER | awk "{ print \$1 }")
#debug
docker-compose -f $BASEPATH/$PROJECT run -T --rm postgres pg_dump postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST/$POSTGRES_DATABASE | gzip > ${timestamp}_${POSTGRES_DATABASE}_dump.sql.gz
