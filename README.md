# Builderism
**User-friendly builder for launch your optimism node**

It support 4 steps to operate OP Stack node
|  Name      | Description                                       | Command      |
| :--------: | ------------------------------------------------- | ------------ |
|  `init`    | deploy bridge contracts and generate l2 configs.  | `make init`  |
|  `run`     | run optimism node using generated configs.        | `make run`   |
|  `scan`    | run blockchain explorer using blockscout.         | `make scan`  |
|  `bridge`  | transfer eth and tokens between L1 and L2.        | `make bridge`|

## Prerequisite
- makefile, docker, docker-compose
- L1 RPC and Beacon endpoint (use PublicNode experimentally)
- faucet private key (for charging eth to proposer, batcher, admin)

## Quick Start
1. Clone this repository `git clone https://github.com/rabbitprincess/builderism.git`
2. Check and modify configuration `common.env`
3. Run Command in sequence to `make init`, `make run`, `make scan`, `make bridge`

## Configuration
### Directory
- `CONFIG_DIR`: Path to store config files (default `../config`)
- `EXECUTION_DATA_DIR`: Path to store execution layer data (default `../data-execution`)
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

### init node
- `PRIORITY_GAS_PRICE`: Gas wei price using deploy contracts (default `10000`)
- `FAUCET_ADDRESS`: Charging address
- `FAUCET_PRIVATE_KEY`: Charging private key; Be careful about security
- `FAUCET_AMOUNT_ADMIN`: Faucet amount eth to admin (default `0.5`)
- `FAUCET_AMOUNT_BATCHER`: Faucet amount eth to batcher (default `0.2`)
- `FAUCET_AMOUNT_PROPOSER`: Faucet amount eth to proposer (default `0.1`)
- `GOVERNANCE_TOKEN_SYMBOL`: Governance token symbol

### run node
- `RUN_MODE`: Run mode ( sequencer or fullnode ) (default `sequencer`)
- `DATA_AVAILABILITY_TYPE`: Data availability type (default `blobs`)
- `MAX_CHANNEL_DURATION`: Batch time submitted to the L1 (default `1500`)
- `SEQUENCER_HTTP`: Sequencer endpoint
- `P2P_BOOTNODES`: Bootnode enr address

## Frequently Asked Questions

### How long time does init take?
- Currently, it takes ~1 hour, so please be patient!
- Most of time is spent on L1 contract deployment.
- You can see the deployment progress in L1 explorer.

### I don`t have enough fee for faucet
- You can take some testnet ethereum from faucet
  - [sepolia pow faucet](https://sepolia-faucet.pk910.de/)
  - [holesky pow faucet](https://holesky-faucet.pk910.de/)
- You can adjust faucet fee. If basefee is 3~4 gwei, Deploying cost is ~0.1 eth.
- Sometimes, sepolia gas fee can be super high. You can also use Holskey testnet.

### How can I run replica node?
- if you run replica node for superchain like op and base,
  - set CHAIN_ENV_FILES for node configs files ( check envs folder ).
- if you run replica node for custom chain,

### When will additional feature supported? ( l3 chain, custom gas token )
- There doesn`t seem to be a guideline or specification yet.
- Any requests or contributes are welcome!
