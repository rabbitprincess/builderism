# optimism-builder
**User-friendly builder for launch your optimism node**

It support 4 steps to operate OP Stack node
|  Command   | Description                                       |
| :--------: | ------------------------------------------------- |
|  `init`    | deploy bridge contracts and generate l2 configs.  |
|  `run`     | run optimism node using generated configs.        |
|  `scan`    | run blockchain explorer using blockscout.         |
|  `bridge`  | transfer eth and tokens between L1 and L2.        |

## prerequisite
- docker, docker-compose
- L1 RPC and Beacon endpoint (use PublicNode experimentally)
- faucet private key (for charging eth to proposer, batcher, admin)

## configuration ( .env.example )
### common
- `CONFIG_DIR`: Path to store config files (default `../config`)
- `GETH_DATA_DIR`: Path to store geth data (default `../data-geth`)
- `SCAN_DATA_DIR`: Path to store explorer data (default `../data-scan`)
- `L1_CHAIN_ID`: L1 chain id
- `L2_CHAIN_ID`: Your L2 chain id
- `L2_CHAIN_NAME`: Your L2 chain name
- `L1_RPC_KIND`: The type of RPC provider
- `L1_RPC_URL`: L1 RPC endpoint
- `L1_BEACON_URL`: L1 Beacon endpoint
- `L2_RPC_URL`: L2 RPC endpoint
- `L2_WS_URL`: L2 WebSocket endpoint

### init node
- `PRIORITY_GAS_PRICE`: Gas price during deploy contracts (default `10000`)
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

### bridge/scan
- `L2_SCAN_URL`: block explorer endpoint
- `L2_BRIDGE_URL`: L2 Bridge endpoint

## init your node
```
make init
```

## run your node
```
make run
```

## run blockscout
```
make scan
```

## bridge eth / erc20 ( L1 <-> L2 )
```
make bridge
```