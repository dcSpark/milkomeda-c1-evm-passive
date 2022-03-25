# Milkomeda EVM Passive <!-- omit in toc -->

Milkomeda EVM node configurations for partners wanting to connect to the evm nodes p2p network

- [Usage](#usage)
  - [Start Script](#start-script)
  - [Docker Compose Direct](#docker-compose-direct)

## Usage

### Start Script
There is a simple start script provided to make starting/stoping/cleaning up easier. By default it will launch the EVM in c1-devnet.

- Script Help for the most up to date commands `./start -h`

- Find Network(s) to start: `./start -l`
- Start EVM: `./start -n $NETWORK -r`
  - Add Log Tailing: `./start -n $NETWORK -r -t`
- Stop EVM: `./start -n $NETWORK -s`
- Tail logs: `./start -n $NETWORK -t`
- Cleanup EVM: `./start -n $NETWORK -c`

### Docker Compose Direct

- Switch to Directory of network you wish to Run EVM in Example: `cd c1-devnet`
- Start EVM:
  - `docker-compose -f docker-compose.yml -p ${NETWORK}-passive build`
  - `docker-compose -f docker-compose.yml -p ${NETWORK}-passive up --detach --force-recreate`
- Stop EVM: `docker-compose -f docker-compose.yml -p ${NETWORK}-passive stop`
- Tail logs: `docker-compose -f docker-compose.yml -p ${NETWORK}-passive logs --follow --tail="all"`
- Cleanup EVM: `docker-compose -f docker-compose.yml -p ${NETWORK}-passive down`