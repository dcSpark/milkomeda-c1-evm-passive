# Milkomeda EVM Passive <!-- omit in toc -->

Milkomeda EVM node configurations for partners wanting to connect to the evm nodes p2p network

**NOTE** Runs as a Archive Node by default

See here for more info <https://besu.hyperledger.org/en/stable/Concepts/Node-Types/>

- [Usage](#usage)
  - [Start Script](#start-script)
  - [Docker Compose Direct](#docker-compose-direct)
- [Config](#config)
  - [Change to Full Node](#change-to-full-node)
- [Troubleshooting](#troubleshooting)
  - [Not Syncing](#not-syncing)
  - [Permission Denied](#permission-denied)
    - [Known Errors for this remediation](#known-errors-for-this-remediation)

## Usage

### Start Script
There is a simple start script provided to make starting/stoping/cleaning up easier. By default it will launch the EVM in c1-devnet.

**NOTE**: Add the `-o` flag to all commands if using WSL & MacOS (disables Host Network mode and Set Ports)

- Script Help for the most up to date commands `./start.sh -h`
- Find Network(s) to start: `./start.sh -l`
- Start EVM: `./start.sh -n ${NETWORK} -r`
  - Add Log Tailing: `./start.sh -n ${NETWORK} -r -t`
- Stop EVM: `./start.sh -n ${NETWORK} -s`
- Tail logs: `./start.sh -n ${NETWORK} -t`
- Cleanup EVM: `./start.sh -n ${NETWORK} -c`

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
**NOTE**: If you enable sync-mode="FAST" then you need 5 peers before it'll begin syncing. The setting to modify this is below

- Edit the config file at `${NETWORK}/config/config.toml`
  - Change `sync-mode="FULL"` to `sync-mode="FAST"`
  - **Optional**: Add number of minimum peers to config file (e.g.; `fast-sync-min-peers=2`). Also can be added to docker-compose.yml under the Command section as `--fast-sync-min-peers=2`

## Troubleshooting

### Not Syncing
1. Pull Latest Updates from Github
2. Trying restarting the service
  - `docker-compose -f docker-compose.yml -p ${NETWORK}-passive restart`
3. If issue persists, run the commands under the [Usage](#usage) section in this order `Stop EVM` `Clean EVM` `Start EVM`

### Permission Denied

If you get a Permission Denied error,  e.g.:
```
root@blockscout:~/milkomeda-evm-passive# docker-compose -f c1-devnet/docker-compose.yml -p c1-devnet-passive up
[+] Running 1/0
 ⠿ Container c1-devnet-passive-besu-1  Created                                                                                                                                                                              0.0s
Attaching to c1-devnet-passive-besu-1
c1-devnet-passive-besu-1  | 2022-04-05 14:14:16,508 main ERROR Unable to create file /tmp/besu/besu-blockscout.log java.io.IOException: Permission denied
```

run the following command(s),
- `chmod a+w -R ${NETWORK}/storage`
  - You may have to restart `docker-compose -f docker-compose.yml -p ${NETWORK}-passive restart`

#### Known Errors for this remediation

```
ANTLR Runtime version 4.7.1 used for parser compilation does not match the current runtime version 4.8/opt/besu/data/DATABASE_METADATA.json (Permission denied)
```
