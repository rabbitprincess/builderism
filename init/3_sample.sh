jsonnet 3_config.jsonnet \
  --ext-code config='{
    ADMIN_ADDRESS: "abcd",
    SEQUENCER_ADDRESS: "abcd",
    BATCHER_ADDRESS: "abcd",
    l2GenesisBlockNonce: "1",
    l2GenesisBlockGasUsed: "0",
    l1ChainID: "1",
    l2ChainID: "10",
    l2BlockTime: "0x0",
  }' > .deploy