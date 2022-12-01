#!/bin/bash

BASE_DIR="${HOME}/workspace"
DB_PW=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c20)
ADMIN_PW=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c20)
DOCKER_GID=$(stat -c '%g' /var/run/docker.sock)

BUILD_DIR="${BASE_DIR}/docker/build/monitoring"
BIN_DIR="${BASE_DIR}/docker/bin"
DATA_DIR="${BASE_DIR}/docker/appdata/monitoring"

if [[ -z "$@" ]]; then
    echo >&2 "Usage: $0 <command>"
    echo >&2 "command = up, down, restart, clean, logs"
    exit 1
fi

case "$1" in
  up)
    cd $BUILD_DIR
    ROOT_DIR=${DATA_DIR} DB_PW="${DB_PW}" ADMIN_PW="${ADMIN_PW}" DOCKER_GID="${DOCKER_GID}" docker-compose -p "Monitoring" up -d
    echo "Go to -- http://${HOSTNAME}:3000"
    echo "Database Password: ${DB_PW}"
    echo "Grafana Admin Password: ${ADMIN_PW}"
    cd $BIN_DIR
  ;;
  down)
    cd $BUILD_DIR
    docker-compose down
    cd $BIN_DIR
  ;;
  restart)
    ./$0 down
    ./$0 up
  ;;
  clean)
    cd $BUILD_DIR
    docker-compose down -v
    cd $BIN_DIR
  ;;
  logs)
    cd $BUILD_DIR
    docker-compose logs
    cd $BIN_DIR
  ;;
  *)
    echo "$0: Error: Invalid option: $1"
    exit 1
  ;;
esac
