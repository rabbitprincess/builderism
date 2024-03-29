# optimism_builder
user-friendly tool to build your optimism mainnet

## configuration

common
```
L1_RPC_URL: Your L1 RPC endpoint
L1_RPC_KIND: The type of RPC provider; valid options are: alchemy, quicknode, infura, parity, nethermind, debug_geth, erigon, basic, any
CONFIG_DIR: generate genesis.json and other configs. it used to run node.
```

init node
```
NETWORK_TYPE: Your L2 mainnet name
L1_CHAIN_ID: L1 chain id ( mainnet=1, sepolia=11155111 )
FAUCET_ADDRESS: Ethereum charging address. required for deploy bridge contract. It requires at least 0.8 eth and additional gas fee.
FAUCET_PRIVATE_KEY: Ethereum charging private key. Be careful about security.
```

run node
```
L1_BEACON_URL: Your L1 Beacon endpoint
GETH_DATA_DIR: Relative path to the directory that will store chain data
SEQUENCER_MODE: if true, run sequencer mode

```

```
sdk

```

## init your node
```
make init
```

## run your node
```
make run
```
