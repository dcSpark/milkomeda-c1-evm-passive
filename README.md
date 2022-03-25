# Milkomeda EVM Passive <!-- omit in toc -->

Milkomeda EVM node configurations for partners wanting to connect to the evm nodes p2p network

**NOTE** Runs as a Archive Node by default

See here for more info <https://besu.hyperledger.org/en/stable/Concepts/Node-Types/>

- [Usage](#usage)
  - [Start Script](#start-script)
  - [Docker Compose Direct](#docker-compose-direct)
- [Config](#config)
  - [Change to Full Node](#change-to-full-node)

## Usage

### Start Script
There is a simple start script provided to make starting/stoping/cleaning up easier. By default it will launch the EVM in c1-devnet.

**NOTE**: Add the `-o` flag to all commands if using WSL & MacOS (disables Host Network mode and Set Ports)

- Script Help for the most up to date commands `./start -h`
- Find Network(s) to start: `./start -l`
- Start EVM: `./start -n $NETWORK -r`
  - Add Log Tailing: `./start -n $NETWORK -r -t`
- Stop EVM: `./start -n $NETWORK -s`
- Tail logs: `./start -n $NETWORK -t`
- Cleanup EVM: `./start -n $NETWORK -c`

### Docker Compose Direct

**NOTE**: Use `docker-compose-non-linux.yaml` instead for WSL & MacOS usage (disables Host Network mode and Set Ports)

- Switch to Directory of network you wish to Run EVM in Example: `cd c1-devnet`
- Start EVM:
  - `docker-compose -f docker-compose.yml -p ${NETWORK}-passive build`
  - `docker-compose -f docker-compose.yml -p ${NETWORK}-passive up --detach --force-recreate`
- Stop EVM: `docker-compose -f docker-compose.yml -p ${NETWORK}-passive stop`
- Tail logs: `docker-compose -f docker-compose.yml -p ${NETWORK}-passive logs --follow --tail="all"`
- Cleanup EVM: `docker-compose -f docker-compose.yml -p ${NETWORK}-passive down`


## Config

### Change to Full Node
- Edit the config file at `$Network/config/config.toml`
- Change `sync-mode="FULL"` to `sync-mode="FAST"`