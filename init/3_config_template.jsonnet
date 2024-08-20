//-----------------------------------------------------------------------//
// functions

local require(key, value) =
  if value == null || value == "" then
    error key + " is required"
  else
    { [key]: value };

local default(key, value, default) =
  { [key]: if value == null || value == "" then default else value };

local include(key, value, condition) =
  if condition then
    { [key]: value }
  else
    {};

local includeIfExist(key, value) =
  include(key, value, value != null && value != "");

//-----------------------------------------------------------------------//
// arguments

local Args = {
  BLOCK = std.extVar("BLOCK"),
  L1_TIMESTAMP = std.extVar("L1_TIMESTAMP"),
  L1_BLOCK_HASH = std.extVar("L1_BLOCK_HASH"),
  L1_CHAIN_ID = std.extVar("L1_CHAIN_ID"),
  L2_CHAIN_ID = std.extVar("L2_CHAIN_ID"),
  SEQUENCER_ADDRESS = std.extVar("SEQUENCER_ADDRESS"),
  BATCHER_ADDRESS = std.extVar("BATCHER_ADDRESS"),
  PROPOSER_ADDRESS = std.extVar("PROPOSER_ADDRESS"),
  ADMIN_ADDRESS = std.extVar("ADMIN_ADDRESS"),
  DEPLOYMENT_CONTEXT = std.extVar("DEPLOYMENT_CONTEXT"),
  GOVERNANCE_TOKEN_SYMBOL = std.extVar("GOVERNANCE_TOKEN_SYMBOL"),
  ALT_DA_SERVER = std.extVar("ALT_DA_SERVER"),
  FUND_DEV_ACCOUNTS = std.extVar("FUND_DEV_ACCOUNTS"),
};

//-----------------------------------------------------------------------//
// elements

// DevDeployConfig
local DevDeployConfig = std.mergePatch(
  default("fundDevAccounts", std.extVar("fundDevAccounts"), false)
);

// L2GenesisBlockDeployConfig
local L2GenesisBlockDeployConfig = std.mergePatch(
  default("l2GenesisBlockNonce", std.extVar("l2GenesisBlockNonce"), 0),
  default("l2GenesisBlockGasLimit", std.extVar("l2GenesisBlockGasLimit"), "0x1c9c380"),  // 30_000_000
  default("l2GenesisBlockDifficulty", std.extVar("l2GenesisBlockDifficulty"), "0x0"),
  default("l2GenesisBlockMixHash", std.extVar("l2GenesisBlockMixHash"), "0x0000000000000000000000000000000000000000000000000000000000000000"),
  default("l2GenesisBlockNumber", std.extVar("l2GenesisBlockNumber"), 0),
  default("l2GenesisBlockGasUsed", std.extVar("l2GenesisBlockGasUsed"), 0),
  default("l2GenesisBlockParentHash", std.extVar("l2GenesisBlockParentHash"), "0x0000000000000000000000000000000000000000000000000000000000000000"),
  default("l2GenesisBlockBaseFeePerGas", std.extVar("l2GenesisBlockBaseFeePerGas"), "0x3b9aca00"),  // 1_000_000_000
  default("l2GenesisBlockExtraData", std.extVar("l2GenesisBlockExtraData"), "0x426544524f434b")
);

local OwnershipDeployConfig = std.mergePatch(
  default("proxyAdminOwner", std.extVar("proxyAdminOwner"), Args.ADMIN_ADDRESS),
  default("finalSystemOwner", std.extVar("finalSystemOwner"), Args.ADMIN_ADDRESS)
);

local L2VaultsDeployConfig = std.mergePatch(
  default("baseFeeVaultRecipient", std.extVar("baseFeeVaultRecipient"), "0x0000000000000000000000000000000000000000"),
  default("l1FeeVaultRecipient", std.extVar("l1FeeVaultRecipient"), "0x0000000000000000000000000000000000000000"),
  default("sequencerFeeVaultRecipient", std.extVar("sequencerFeeVaultRecipient"), "0x0000000000000000000000000000000000000000"),
  default("baseFeeVaultMinimumWithdrawalAmount", std.extVar("baseFeeVaultMinimumWithdrawalAmount"), "0x8ac7230489e80000"),
  default("l1FeeVaultMinimumWithdrawalAmount", std.extVar("l1FeeVaultMinimumWithdrawalAmount"), "0x8ac7230489e80000"),
  default("sequencerFeeVaultMinimumWithdrawalAmount", std.extVar("sequencerFeeVaultMinimumWithdrawalAmount"), "0x8ac7230489e80000"),
  default("baseFeeVaultWithdrawalNetwork", std.extVar("baseFeeVaultWithdrawalNetwork"), 0),
  default("l1FeeVaultWithdrawalNetwork", std.extVar("l1FeeVaultWithdrawalNetwork"), 0),
  default("sequencerFeeVaultWithdrawalNetwork", std.extVar("sequencerFeeVaultWithdrawalNetwork"), 0)
);

// Governance configuration based on the presence of GOVERNANCE_TOKEN_SYMBOL
local GovConfig = if std.length(GOVERNANCE_TOKEN_SYMBOL) > 0 then {
  enableGovernance: true,
  governanceTokenSymbol: GOVERNANCE_TOKEN_SYMBOL,
  governanceTokenName: GOVERNANCE_TOKEN_SYMBOL,
  governanceTokenOwner: ADMIN_ADDRESS,
} else {
  enableGovernance: false,
  governanceTokenSymbol: "NA",
  governanceTokenName: "NotApplicable",
  governanceTokenOwner: ADMIN_ADDRESS,
};

local GasPriceOracleDeployConfig = std.mergePatch(
  default("gasPriceOracleOverhead", std.extVar("gasPriceOracleOverhead"), 2100),
  default("gasPriceOracleScalar", std.extVar("gasPriceOracleScalar"), 1000000),
  default("gasPriceOracleBaseFeeScalar", std.extVar("gasPriceOracleBaseFeeScalar"), 1368),
  default("gasPriceOracleBlobBaseFeeScalar", std.extVar("gasPriceOracleBlobBaseFeeScalar"), 810949)
);

local GasTokenDeployConfig = std.mergePatch(
  default("useCustomGasToken", std.extVar("useCustomGasToken"), false),
  optional("customGasTokenAddress", std.extVar("customGasTokenAddress"))
);

// OperatorDeployConfig
local OperatorDeployConfig = std.mergePatch(
  default("p2pSequencerAddress", std.extVar("p2pSequencerAddress"), "0x0000000000000000000000000000000000000000"),
  default("batchSenderAddress", std.extVar("batchSenderAddress"), "0x0000000000000000000000000000000000000000")
);

// EIP1559DeployConfig
local EIP1559DeployConfig = std.mergePatch(
  default("eip1559Elasticity", std.extVar("eip1559Elasticity"), 6),
  default("eip1559Denominator", std.extVar("eip1559Denominator"), 50),
  default("eip1559DenominatorCanyon", std.extVar("eip1559DenominatorCanyon"), 250)
);

// UpgradeScheduleDeployConfig
local UpgradeScheduleDeployConfig = std.mergePatch(
  default("l2GenesisRegolithTimeOffset", std.extVar("l2GenesisRegolithTimeOffset"), "0x0"),
  default("l2GenesisCanyonTimeOffset", std.extVar("l2GenesisCanyonTimeOffset"), "0x0"),
  default("l2GenesisDeltaTimeOffset", std.extVar("l2GenesisDeltaTimeOffset"), "0x0"),
  default("l2GenesisEcotoneTimeOffset", std.extVar("l2GenesisEcotoneTimeOffset"), "0x0"),
  default("l2GenesisFjordTimeOffset", std.extVar("l2GenesisFjordTimeOffset"), "0x0"),
  default("l2GenesisGraniteTimeOffset", std.extVar("l2GenesisGraniteTimeOffset"), "0x0"),
  default("l2GenesisInteropTimeOffset", std.extVar("l2GenesisInteropTimeOffset"), "0x0"),
  default("useInterop", std.extVar("useInterop"), false)
);

local L2CoreDeployConfig = std.mergePatch(
  default("l1ChainID", std.extVar("l1ChainID"), Args.L1_CHAIN_ID),
  default("l2ChainID", std.extVar("l2ChainID"), Args.L2_CHAIN_ID),
  default("l2BlockTime", std.extVar("l2BlockTime"), Args.L1_TIMESTAMP),
  default("finalizationPeriodSeconds", std.extVar("finalizationPeriodSeconds"), 604800),
  default("maxSequencerDrift", std.extVar("maxSequencerDrift"), 600),
  default("sequencerWindowSize", std.extVar("sequencerWindowSize"), 3600),
  default("channelTimeoutBedrock", std.extVar("channelTimeoutBedrock"), 300),
  default("channelTimeoutGranite", std.extVar("channelTimeoutGranite"), 0),
  default("batchInboxAddress", std.extVar("batchInboxAddress"), "0xff00000000000000000000000000000000000000"[:(-std.length(Args.L2_CHAIN_ID))] + Args.L2_CHAIN_ID),
  default("systemConfigStartBlock", std.extVar("systemConfigStartBlock"), 0)
);

// Alternative DA configuration based on the presence of ALT_DA_SERVER
local AltDaConfig = if std.length(ALT_DA_SERVER) > 0 then {
  usePlasma: true,
  daCommitmentType: "KeccakCommitment",
  daChallengeWindow: 16,
  daResolveWindow: 16,
  daBondSize: 1000000,
  daResolverRefundPercentage: 0,
} else {};

//-----------------------------------------------------------------------//
// output
{
  l1StartingBlockTag: blockhash,

  + DevDeployConfig
  + L2GenesisBlockDeployConfig

  

  l1ChainID: L1_CHAIN_ID,
  l2ChainID: L2_CHAIN_ID,
  l2BlockTime: 2,
  l1BlockTime: 12,

  maxSequencerDrift: 600,
  sequencerWindowSize: 3600,
  channelTimeout: 300,

  p2pSequencerAddress: SEQUENCER_ADDRESS,
  batchInboxAddress: BatchInboxAddress,
  batchSenderAddress: BATCHER_ADDRESS,

  l2OutputOracleSubmissionInterval: 1800,
  l2OutputOracleStartingBlockNumber: 0,
  l2OutputOracleStartingTimestamp: timestamp,

  l2OutputOracleProposer: PROPOSER_ADDRESS,
  l2OutputOracleChallenger: ADMIN_ADDRESS,

  finalizationPeriodSeconds: 12,

  proxyAdminOwner: ADMIN_ADDRESS,
  baseFeeVaultRecipient: ADMIN_ADDRESS,
  l1FeeVaultRecipient: ADMIN_ADDRESS,
  sequencerFeeVaultRecipient: ADMIN_ADDRESS,
  finalSystemOwner: ADMIN_ADDRESS,
  superchainConfigGuardian: ADMIN_ADDRESS,

  baseFeeVaultMinimumWithdrawalAmount: "0x8ac7230489e80000",
  l1FeeVaultMinimumWithdrawalAmount: "0x8ac7230489e80000",
  sequencerFeeVaultMinimumWithdrawalAmount: "0x8ac7230489e80000",
  baseFeeVaultWithdrawalNetwork: 0,
  l1FeeVaultWithdrawalNetwork: 0,
  sequencerFeeVaultWithdrawalNetwork: 0,

  gasPriceOracleOverhead: 2100,
  gasPriceOracleScalar: 1000000,
  gasPriceOracleBaseFeeScalar: 1368,
  gasPriceOracleBlobBaseFeeScalar: 810949,

  // Include the governance and alternative DA configurations
  + govConfig,
  + altDaConfig,

  l2GenesisBlockGasLimit: "0x1c9c380",
  l2GenesisBlockBaseFeePerGas: "0x3b9aca00",
  l2GenesisRegolithTimeOffset: "0x0",
  l2GenesisCanyonTimeOffset: "0x0",
  l2GenesisDeltaTimeOffset: "0x0",
  l2GenesisEcotoneTimeOffset: "0x0",

  eip1559Denominator: 50,
  eip1559DenominatorCanyon: 250,
  eip1559Elasticity: 6,

  systemConfigStartBlock: 0,

  requiredProtocolVersion: "0x0000000000000000000000000000000000000004000000000000000000000000",
  recommendedProtocolVersion: "0x0000000000000000000000000000000000000004000000000000000000000000",
  fundDevAccounts: false,
  faultGameAbsolutePrestate: "0x037ef3c1a487960b0e633d3e513df020c43432769f41a634d18a9595cbf53c55",
  faultGameMaxDepth: 73,
  faultGameClockExtension: 10800,
  faultGameMaxClockDuration: 302400,
  faultGameGenesisBlock: 0,
  faultGameGenesisOutputRoot: "0x0000000000000000000000000000000000000000000000000000000000000000",
  faultGameSplitDepth: 30,
  faultGameWithdrawalDelay: 604800,
  preimageOracleMinProposalSize: 126000,
  preimageOracleChallengePeriod: 86400,
  proofMaturityDelaySeconds: 604800,
  disputeGameFinalityDelaySeconds: 302400,
  respectedGameType: 0,
  useFaultProofs: true
}