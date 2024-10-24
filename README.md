# Builderism
**User-friendly builder for launch your optimism node**

It support 4 steps to operate OP Stack node
|  Name      | Description                                                                   | Command      |
| :--------: | ----------------------------------------------------------------------------- | ------------ |
|  `init`    | deploy bridge contracts and generate l2 configs.                              | `make init`  |
|  `run`     | run sequencer or replica node                                                 | `make run`   |
|  `scan`    | run blockchain explorer using [op-scan](https://github.com/walnuthq/op-scan). | `make scan`  |
|  `bridge`  | transfer eth and tokens between L1 and L2.                                    | `make bridge`|

## Prerequisite
- makefile, docker, docker-compose
- L1 RPC and Beacon endpoint (use PublicNode experimentally)
- faucet private key (for charging eth to proposer, batcher, admin)

## Quick Start
1. Clone this repository `git clone https://github.com/rabbitprincess/builderism.git`
2. Check and select chain configuration in `common.env` and `/envs/{server}.env`
3. Run Command in sequence to `make init`, `make run`, `make scan`, `make bridge`

## Supported Replica Networks
|                    | Available     | Superchain Registry  | Snapshot Support     |
|--------------------|---------------|----------------------|----------------------|
| op-mainnet         | ✅            | ✅                  | ✅                  | 
| op-sepolia         | ✅            | ✅                  | ✅                  | 
| base-mainnet       | ✅            | ✅                  | ✅                  | 
| base-sepolia       | ✅            | ✅                  | ✅                  | 
| worldchain-mainnet | ✅            | ❌                  | ❌                  | 
| worldchain-sepolia | ✅            | ❌                  | ❌                  | 
| unichain-mainnet   | ❌            | ❌                  | ❌                  | 
| unichain-sepolia   | ✅            | ❌                  | ❌                  |

## Frequently Asked Questions
**Q. I don`t have enough fee for faucet**
- You can take some eth from faucet
  - [sepolia pow faucet](https://sepolia-faucet.pk910.de/)
  - [holesky pow faucet](https://holesky-faucet.pk910.de/)
- You can adjust faucet amount. If basefee is 3~4 gwei, Deploying cost is ~0.1 eth.
- Sometimes sepolia gas price can be too high. You can also use Holskey testnet.

**Q. How long time does init take?**
- Currently, it takes ~1 hour, so please be patient!
- Most of time is spent on contract deployment.
- If you see `[all process is done! check config files.]` message, init process is successfully done.

**Q. I want to change configuration not in ENV files.**
- you can modify all `entrypoint` as needed.
- all script is mounted in docker volume, so there is no need to rebuild docker images.

**Q. How can run replica node?**
- If run Superchain Network, just use env file in /envs.
- If run not Superchain node, you should set `rollup.json` and `genesis.json` in `config` directory.

**Q. When will additional features be supported?**
- `ALT DA` is enabled. Set `ALT_DA_SERVER` to your alt-da server url.
- `Custom Gas Token` is also enabled. Change branch to `feature/custom-gas-token` and set `GAS_TOKEN_ADDRESS` to your token address.
- `L3 Chain` is not suported yet.

## Configuration
### Directory
- `CONFIG_DIR`: Path to store config files (default `../config`)
- `GETH_DATA_DIR`: Path to store geth data (default `../data-geth`)
- `SCAN_DATA_DIR`: Path to store explorer data (default `../data-scan`)

### L1 chain
- `L1_CHAIN_ID`: L1 chain id (default `11155111`)
- `L1_RPC_KIND`: The type of RPC provider (default `standard`)
- `L1_RPC_URL`: L1 RPC endpoint (default `publicNode`)
- `L1_BEACON_URL`: L1 Beacon endpoint (default `publicNode`)

### L2 chain
- `L2_CHAIN_ID`: Your L2 chain id
- `L2_CHAIN_NAME`: Your L2 chain name
- `L2_RPC_URL`: Your L2 RPC endpoint
- `L2_SCAN_URL`: L2 Explore endpoint
- `L2_BRIDGE_URL`: L2 Bridge endpoint
- `ALT_DA_SERVER`: ALT DA server url; if empty, use eth DA

### init node
- `PRIORITY_GAS_PRICE`: Gas wei price using deploy contracts (default `10000`)
- `FAUCET_ADDRESS`: Charging address
- `FAUCET_PRIVATE_KEY`: Charging private key; Be careful about security
- `FAUCET_AMOUNT_ADMIN`: Faucet amount eth to admin (default `0.5`)
- `FAUCET_AMOUNT_BATCHER`: Faucet amount eth to batcher (default `0.2`)
- `FAUCET_AMOUNT_PROPOSER`: Faucet amount eth to proposer (default `0.1`)
- `GOVERNANCE_TOKEN_SYMBOL`: Governance token symbol

### run node
- `RUN_MODE`: Run mode ( sequencer or replica ) (default `sequencer`)
- `MAX_CHANNEL_DURATION`: Batch time submitted to the L1 (default `1500`)
- `SEQUENCER_HTTP`: Sequencer endpoint
- `P2P_BOOTNODES`: Bootnode enr address
- `DOWNLOAD_SNAPSHOT`: Download snapshot before run node