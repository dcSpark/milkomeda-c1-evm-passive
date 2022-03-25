#!/usr/bin/env bash
# This file:
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

##############################################################################
# Functions
##############################################################################

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

runEvm() {
  docker-compose -f ${NETWORK}/docker-compose.yml -p ${NETWORK}-passive build
  docker-compose -f ${NETWORK}/docker-compose.yml -p ${NETWORK}-passive up --detach --force-recreate
}
stopEvm() {
  docker-compose -f ${NETWORK}/docker-compose.yml -p ${NETWORK}-passive stop
}

cleanEvm() {
  stopEvm
  docker-compose -f ${NETWORK}/docker-compose.yml -p ${NETWORK}-passive down
}

logsEvm() {
  docker-compose -f ${NETWORK}/docker-compose.yml -p ${NETWORK}-passive logs --follow --tail="all"
}

export -f getNetworks
export -f runEvm
export -f stopEvm
export -f cleanEvm
export -f logsEvm

print_help() {
  echo ">>> Usage:"
  echo "Run EVM: ./start -n c1-devnet -r"
  echo "Run EVM & Tail Logs: ./start -n c1-devnet -r -t"
  echo "Stop EVM: ./start -n c1-devnet -s"
  echo "Tail EVM Logs: ./start -n c1-devnet -t"
  echo "Cleanup EVM Contains: ./start -n c1-devnet -c"
  echo ""
  echo ">>> Flags:"
  echo "-n | Milkomeda EVM Network to Run - Default: ${NETWORK}"
  echo "-l | List all networks that can be ran"
  echo "-r | Pass to Run the EVM Network"
  echo "-s | Pass to Stop the EVM Network"
  echo "-t | Pass to tail logs of the EVM Network"
  echo "-c | Pass to cleanup the EVM Network containers"
  echo "-h | List this help menu"
}

while getopts n:hlrstc option; do
  case "${option}" in

  n) export NETWORK=${OPTARG} ;;
  r) runEvm ;;
  s) stopEvm ;;
  t) logsEvm ;;
  c) cleanEvm ;;
  l) getNetworks ;;
  h)
    print_help
    exit 2
    ;;
  esac
done
