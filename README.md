# Optimism-builder
**User-friendly builder for launch your optimism node**

It support 4 steps to operate OP Stack node
|  Name      | Description                                       | Command      |
| :--------: | ------------------------------------------------- | ------------ |
|  `init`    | deploy bridge contracts and generate l2 configs.  | `make init`  |
|  `run`     | run optimism node using generated configs.        | `make run`   |
|  `scan`    | run blockchain explorer using blockscout.         | `make scan`  |
|  `bridge`  | transfer eth and tokens between L1 and L2.        | `make bridge`|

## Prerequisite
- docker, docker-compose
- L1 RPC and Beacon endpoint (use PublicNode experimentally)
- faucet private key (for charging eth to proposer, batcher, admin)

## Quick Start
1. Clone this repository
2. Check and modify configuration `.env.example`
3. Run Command in sequence to `make init`, `make run`, `make scan`, `make bridge`

## Configuration
### common
| Option          | Description                | Default Value  |
| ----------------|----------------------------|----------------|
| `CONFIG_DIR`    | Path to store config files | `../config`    |
| `GETH_DATA_DIR` | Path to store config files | `../data-geth` |
| `SCAN_DATA_DIR` | Path to store config files | `../data-scan` |
| `L1_CHAIN_ID`   | L1 chain id                | `11155111`     |
| `L1_RPC_KIND`   | The type of RPC provider   | `standard`     |
| `L1_RPC_URL`    | L1 RPC endpoint            | `publicNode`   |
| `L1_BEACON_URL` | L1 Beacon endpoint         | `publicNode`   |
| `L2_CHAIN_ID`   | Your L2 chain id           |                |
| `L2_CHAIN_ID`   | Your L2 chain name         |                |
| `L2_RPC_URL`    | Your L2 RPC endpoint       |                |
| `L2_SCAN_URL`   | L2 Explore endpoint        |                |
| `L2_BRIDGE_URL` | L2 Bridge endpoint         |                |

### init node
- `PRIORITY_GAS_PRICE`: Gas price using deploy contracts (default `10000`)
- `FAUCET_ADDRESS`: Charging address
- `FAUCET_PRIVATE_KEY`: Charging private key; Be careful about security
- `FAUCET_AMOUNT_ADMIN`: Faucet amount eth to admin (default `0.5`)
- `FAUCET_AMOUNT_BATCHER`: Faucet amount eth to batcher (default `0.2`)
- `FAUCET_AMOUNT_PROPOSER`: Faucet amount eth to proposer (default `0.1`)

### run node
- `SEQUENCER_MODE`: If true, run sequencer mode (default `true`)
- `MAX_CHANNEL_DURATION`: batch time submitted to the L1. (default `1500`)
- `SEQUENCER_HTTP`: Sequencer node URL, only used for not sequencer mode
- `BOOTNODES`: Bootnode URL, only used for not sequencer mode
