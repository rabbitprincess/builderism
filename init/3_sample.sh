jsonnet ./3_config.jsonnet --ext-code config='{
  ADMIN_ADDRESS: "ADMIN_ADDRESS",
  BATCHER_ADDRESS: "BATCHER_ADDRESS",
  SEQUENCER_ADDRESS: "SEQUENCER_ADDRESS",
  TIMESTAMP: "timestamp",
  l1ChainID: "L1_CHAIN_ID",
  l2ChainID: "L2_CHAIN_ID",
  l2BlockTime: "timestamp",
  l1StartingBlockTag: "blockhash",
}' > .deploy