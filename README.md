# optimism_builder
user-friendly tool to build your optimism mainnet

## configuration

common
```
CONFIG_DIR: generate genesis.json and other configs. it used to run node.
L1_CHAIN_ID: L1 chain id ( mainnet=1, sepolia=11155111 )
L1_RPC_URL: Your L1 RPC endpoint
L1_RPC_KIND: The type of RPC provider; valid options are: alchemy, quicknode, infura, 
parity, nethermind, debug_geth, erigon, basic, any
L2_CHAIN_ID: Your L2 chain id
L2_CHAIN_NAME: Your L2 chain name
```

init node
```
FAUCET_ADDRESS: Ethereum charging address. required for deploy bridge contract. It requires at least 0.8 eth and additional gas fee.
FAUCET_PRIVATE_KEY: Ethereum charging private key. Be careful about security.
```

run node
```
L1_BEACON_URL: Your L1 Beacon endpoint
GETH_DATA_DIR: Relative path to the directory that will store chain data
SEQUENCER_MODE: if true, run sequencer mode
SEQUENCER_PRIVATE_KEY: Sequencer private key, only used for sequencer mode
BATCHER_PRIVATE_KEY: Batcher private key, only used for sequencer mode
L2OO_ADDRESS: L2OutputOrable address, only used for sequcer mode
SEQUENCER_HTTP: Sequencer node url, only used for not sequencer mode
BOOTNODES: bootnode url, only used for not sequencer mode
```

sdk
```
ADDRESS_MANAGER: contract manager address, deployed during node init
L1_CROSS_DOMAIN_MESSANGER_PROXY:
L1_STANDARD_BRIDGE_PROXY:
L2_OUTPUT_ORACLE_PROXY:
OPTIMISM_PORTAL_PROXY:
```

## init your node
```
make init
```

## run your node
```
make run
```
