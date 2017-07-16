#!/bin/bash
: ${CONTAINER_NAME:="ezdockervertcoin_vertcoin_1"}
docker exec ${CONTAINER_NAME} vertcoin-cli "$@"
