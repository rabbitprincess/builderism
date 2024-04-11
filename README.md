# optimism_builder
user-friendly tool to build your optimism mainnet

## configuration ( .env.example )
### common
```
  CONFIG_DIR                generate genesis.json and other configs.
  L1_CHAIN_ID               L1 chain id ( mainnet=1, sepolia=11155111 )
  L1_RPC_URL                Your L1 RPC endpoint
  L1_RPC_KIND               The type of RPC provider ( default "standard" )
  L2_CHAIN_ID               Your L2 chain id
```

### init node
```
  PRIORITY_GAS_PRICE        gas price during deploy contracts ( default 10000 )
  FAUCET_ADDRESS            charging address
  FAUCET_PRIVATE_KEY        charging private key; Be careful about security
  FAUCET_AMOUNT_ADMIN       faucet amount eth to admin ( default 0.5 )
  FAUCET_AMOUNT_BATCHER     faucet amount eth to batcher ( default 0.2 )
  FAUCET_AMOUNT_PROPOSER    faucet amount eth to proposer ( default 0.1 )
```

### run node
```
  L1_BEACON_URL             Your L1 Beacon endpoint
  GETH_DATA_DIR             Relative path to the directory that will store chain data
  SEQUENCER_MODE            if true, run sequencer mode
  BATCHER_PRIVATE_KEY       Batcher private key, only used for sequencer mode
  PROPOSER_PRIVATE_KEY       Batcher private key, only used for sequencer mode
  SEQUENCER_PRIVATE_KEY     Sequencer private key, only used for sequencer mode
  L2OO_ADDRESS              L2OutputOrable address, only used for sequcer mode
  SEQUENCER_HTTP            Sequencer node url, only used for not sequencer mode
  BOOTNODES                 bootnode url, only used for not sequencer mode
```

### sdk
```
  ADDRESS_MANAGER           contract manager address, deployed during node init
  L1_CROSS_DOMAIN_MESSANGER 
  L1_STANDARD_BRIDGE_PROXY
  L2_OUTPUT_ORACLE_PROXY
  OPTIMISM_PORTAL_PROXY
```

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
