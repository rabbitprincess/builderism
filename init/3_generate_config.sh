#!/bin/bash

# !!!!check https://docs.optimism.io/builders/chain-operators/management/configuration!!!!!
# original path : https://github.com/ethereum-optimism/optimism\packages\contracts-bedrock\scripts\getting-started\config.sh
# This script is used to generate the getting-started.json configuration file
# used in the Getting Started quickstart guide on the docs site. Avoids the
# need to have the getting-started.json committed to the repo since it's an
# invalid JSON file when not filled in, which is annoying.

echo "[3/5] : generate config"

# Get the finalized block timestamp and hash
block=$(cast block finalized --rpc-url "$L1_RPC_URL")
timestamp=$(echo "$block" | awk '/timestamp/ { print $2 }')
blockhash=$(echo "$block" | awk '/hash/ { print $2 }')

# generate the batch inbox address by L2_CHAIN_ID
base_address="0xff00000000000000000000000000000000000000"
BatchInboxAddress="${base_address%${base_address: -${#L2_CHAIN_ID}}}$L2_CHAIN_ID"

govConfig=""
if [ -n "$GOVERNANCE_TOKEN_SYMBOL" ]; then
  govConfig=$(cat << EOL
  "enableGovernance": true,
  "governanceTokenSymbol": "$GOVERNANCE_TOKEN_SYMBOL",
  "governanceTokenName": "$GOVERNANCE_TOKEN_SYMBOL",
  "governanceTokenOwner": "$ADMIN_ADDRESS",
EOL
  )
else
govConfig=$(cat << EOL
  "enableGovernance": false,
  "governanceTokenSymbol": "NA",
  "governanceTokenName": "NotApplicable",
  "governanceTokenOwner": "$ADMIN_ADDRESS",
EOL
  )
fi

# Generate the config file
config=$(cat << EOL
{
  "l1StartingBlockTag": "$blockhash",

  "l1ChainID": $L1_CHAIN_ID,
  "l2ChainID": $L2_CHAIN_ID,
  "l2BlockTime": 2,
  "l1BlockTime": 12,

  "maxSequencerDrift": 600,
  "sequencerWindowSize": 3600,
  "channelTimeout": 300,

  "p2pSequencerAddress": "$SEQUENCER_ADDRESS",
  "batchInboxAddress": "$BatchInboxAddress",
  "batchSenderAddress": "$BATCHER_ADDRESS",

  "l2OutputOracleSubmissionInterval": 1800,
  "l2OutputOracleStartingBlockNumber": 0,
  "l2OutputOracleStartingTimestamp": $timestamp,

  "l2OutputOracleProposer": "$PROPOSER_ADDRESS",
  "l2OutputOracleChallenger": "$ADMIN_ADDRESS",

  "finalizationPeriodSeconds": 12,

  "proxyAdminOwner": "$ADMIN_ADDRESS",
  "baseFeeVaultRecipient": "$ADMIN_ADDRESS",
  "l1FeeVaultRecipient": "$ADMIN_ADDRESS",
  "sequencerFeeVaultRecipient": "$ADMIN_ADDRESS",
  "finalSystemOwner": "$ADMIN_ADDRESS",
  "superchainConfigGuardian": "$ADMIN_ADDRESS",

  "baseFeeVaultMinimumWithdrawalAmount": "0x8ac7230489e80000",
  "l1FeeVaultMinimumWithdrawalAmount": "0x8ac7230489e80000",
  "sequencerFeeVaultMinimumWithdrawalAmount": "0x8ac7230489e80000",
  "baseFeeVaultWithdrawalNetwork": 0,
  "l1FeeVaultWithdrawalNetwork": 0,
  "sequencerFeeVaultWithdrawalNetwork": 0,

  "gasPriceOracleOverhead": 2100,
  "gasPriceOracleScalar": 1000000,
  "gasPriceOracleBaseFeeScalar": 1368,
  "gasPriceOracleBlobBaseFeeScalar": 810949,

$govConfig

  "l2GenesisBlockGasLimit": "0x1c9c380",
  "l2GenesisBlockBaseFeePerGas": "0x3b9aca00",
  "l2GenesisRegolithTimeOffset": "0x0",
  "l2GenesisCanyonTimeOffset": "0x0",
  "l2GenesisDeltaTimeOffset": "0x0",
  "l2GenesisEcotoneTimeOffset": "0x0",

  "eip1559Denominator": 50,
  "eip1559DenominatorCanyon": 250,
  "eip1559Elasticity": 6,

  "systemConfigStartBlock": 0,

  "requiredProtocolVersion": "0x0000000000000000000000000000000000000004000000000000000000000000",
  "recommendedProtocolVersion": "0x0000000000000000000000000000000000000004000000000000000000000000",
  "fundDevAccounts": false,
  "faultGameAbsolutePrestate": "0x037ef3c1a487960b0e633d3e513df020c43432769f41a634d18a9595cbf53c55",
  "faultGameMaxDepth": 73,
  "faultGameClockExtension": 10800,
  "faultGameMaxClockDuration": 302400,
  "faultGameGenesisBlock": 0,
  "faultGameGenesisOutputRoot": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "faultGameSplitDepth": 30,
  "faultGameWithdrawalDelay": 604800,
  "preimageOracleMinProposalSize": 126000,
  "preimageOracleChallengePeriod": 86400,
  "proofMaturityDelaySeconds": 604800,
  "disputeGameFinalityDelaySeconds": 302400,
  "respectedGameType": 0,
  "useFaultProofs": true
} 
EOL
)

# Write the config file
cd ~/optimism/packages/contracts-bedrock && \
mkdir -p ./deployments/$DEPLOYMENT_CONTEXT && \
echo "$config" > ./deployments/$DEPLOYMENT_CONTEXT/.deploy