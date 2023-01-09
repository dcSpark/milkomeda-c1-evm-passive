#!/usr/bin/env bash

#                           @@@@@@@@@@@@
#                       @@@@@@@@@@@@@@@@@
#                   @@@@@@@@@@@@@@@@@@@@@@@@     @@@@@@
#               @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    @@@@
#           @@@@@@@@@@@@@@@@          @@@@@@@@@@
#      @@@@@@@@@@@@@@@@@     *******    @@@@@@          @@@
#  @@@@@@@@@@@@@@@@@        **********              @@@@@@@@
#   @@@@@@@@@@@@           ***********          @@@@@@@@@@@@@@
#    @@@@@@           @@    **********     @@@@@@@@@@@@@@@@@
#                @@@@@@@@@      **     @@@@@@@@@@@@@@@@@
#                 @@@@@@@@@@@@     @@@@@@@@@@@@@@@@@
#         @@@@@@    @@@@@@@@@@@@@@@@@@@@@@@@@@@
#          @@@@@       @@@@@@@@@@@@@@@@@@@@
#                          @@@@@@@@@@@@
# Usage:
#
#  ./start.sh -h

set -o errexit
set -o nounset
set -o pipefail

: ${NETWORK:='c1-devnet'}
: ${COMPOSE_FILE:='docker-compose.yml'}
: ${RUN:=''}
: ${STOP:=''}
: ${TAIL:=''}
: ${CLEAN:=''}

function getNetworks() {
  if [ -n "$(command -v stat)" ]; then
    stat -c "%n" * | grep 'net'
  elif [[ -n "$(command -v ls)" && ! "$(command -v ls)" =~ "exa" ]]; then
    /usr/bin/ls -d --format=single-column * | grep 'net'
  elif [ -n "$(command -v find)" ]; then
    find -maxdepth 1 -type d -printf '%f\n' | grep net
  else
    echo "ERROR: Cannot find state, ls, or find to list networks"
    echo "Networks are just based on folder names (e.g.; ./start -r c1-devnet)"
  fi
}

export -f getNetworks

print_help() {
  echo ">>> Usage:"
  echo "Run EVM: ./start.sh -n c1-devnet -r"
  echo "Run EVM & Tail Logs: ./start.sh -n c1-devnet -r -t"
  echo "Stop EVM: ./start -n c1-devnet -s"
  echo "Tail EVM Logs: ./start.sh -n c1-devnet -t"
  echo "Cleanup EVM Contains: ./start.sh -n c1-devnet -c"
  echo ""
  echo ">>> Flags:"
  echo "-n | Milkomeda EVM Network to Run - Default: ${NETWORK}"
  echo "-l | List all networks that can be ran"
  echo "-r | Pass to Run the EVM Network"
  echo "-s | Pass to Stop the EVM Network"
  echo "-t | Pass to tail logs of the EVM Network"
  echo "-c | Pass to cleanup the EVM Network containers"
  echo "-o | Pass this Flag for non-linux Systems (disables Host Network and sets local Ports)"
  echo "-h | List this help menu"
}

while getopts n:ohlrstc option; do
  case "${option}" in

  n) export NETWORK=${OPTARG} ;;
  r) export RUN="TRUE" ;;
  s) export STOP="TRUE" ;;
  t) export TAIL="TRUE" ;;
  c) export CLEAN="true" ;;
  o) export COMPOSE_FILE="docker-compose-non-linux.yml" ;;
  l) getNetworks ;;
  h)
    print_help
    exit 2
    ;;
  esac
done

runEvm() {
  docker-compose -f ${NETWORK}/${COMPOSE_FILE} -p ${NETWORK}-passive build
  docker-compose -f ${NETWORK}/${COMPOSE_FILE} -p ${NETWORK}-passive up --detach --force-recreate
}
stopEvm() {
  docker-compose -f ${NETWORK}/${COMPOSE_FILE} -p ${NETWORK}-passive stop
}

cleanEvm() {
  stopEvm
  docker-compose -f ${NETWORK}/${COMPOSE_FILE} -p ${NETWORK}-passive down
}

logsEvm() {
  docker-compose -f ${NETWORK}/${COMPOSE_FILE} -p ${NETWORK}-passive logs --follow --tail="all"
}

export -f runEvm
export -f stopEvm
export -f cleanEvm
export -f logsEvm

if [ -n "${RUN}" ]; then
  runEvm
fi

if [ -n "${STOP}" ]; then
  stopEvm
fi

if [ -n "${CLEAN}" ]; then
  cleanEvm
fi

if [ -n "${TAIL}" ]; then
  logsEvm
fi
