//-----------------------------------------------------------------------//
// configs

local config = std.extVar("config");

// if not exist conf, throw an error
local require(key, conf) =
  if std.objectHas(config, conf) then
    { [key]: config[conf] }
  else
    error "required field not found :" + conf;

// if not exist conf, return the default value
local default(key, conf, default) =
  if std.objectHas(config, conf) then
    { [key]: config[conf] }
  else
    { [key]: default };

// if not exist conf, return empty
local optional(key, conf) =
  if std.objectHas(config, conf) then
    { [key]: config[conf] }
  else
    {};

//-----------------------------------------------------------------------//
// elements

local L1StartingBlockTag =
  require("l1StartingBlockTag", "l1StartingBlockTag");

local DevDeployConfig =
  default("fundDevAccounts", "fundDevAccounts", false);

local L2GenesisBlockDeployConfig =
  optional("l2GenesisBlockNonce", "l2GenesisBlockNonce")
  + default("l2GenesisBlockGasLimit", "l2GenesisBlockGasLimit", "0x1c9c380") // 30_000_000
  + optional("l2GenesisBlockDifficulty", "l2GenesisBlockDifficulty")
  + optional("l2GenesisBlockMixHash", "l2GenesisBlockMixHash")
  + optional("l2GenesisBlockNumber", "l2GenesisBlockNumber")
  + optional("l2GenesisBlockGasUsed", "l2GenesisBlockGasUsed")
  + optional("l2GenesisBlockParentHash", "l2GenesisBlockParentHash")
  + default("l2GenesisBlockBaseFeePerGas", "l2GenesisBlockBaseFeePerGas", "0x3b9aca00") // 1_000_000_000
  + optional("l2GenesisBlockExtraData", "l2GenesisBlockExtraData");

local OwnershipDeployConfig =
  require("proxyAdminOwner", "ADMIN_ADDRESS")
  + require("finalSystemOwner", "ADMIN_ADDRESS");

local L2VaultsDeployConfig =
  require("baseFeeVaultRecipient", "ADMIN_ADDRESS")
  + require("l1FeeVaultRecipient", "ADMIN_ADDRESS")
  + require("sequencerFeeVaultRecipient", "ADMIN_ADDRESS")
  + default("baseFeeVaultMinimumWithdrawalAmount", "baseFeeVaultMinimumWithdrawalAmount", "0x8ac7230489e80000") // 10000000000000000000
  + default("l1FeeVaultMinimumWithdrawalAmount", "l1FeeVaultMinimumWithdrawalAmount", "0x8ac7230489e80000") // 10000000000000000000
  + default("sequencerFeeVaultMinimumWithdrawalAmount", "sequencerFeeVaultMinimumWithdrawalAmount", "0x8ac7230489e80000") // 10000000000000000000
  + default("baseFeeVaultWithdrawalNetwork", "baseFeeVaultWithdrawalNetwork", 0)
  + default("l1FeeVaultWithdrawalNetwork", "l1FeeVaultWithdrawalNetwork", 0)
  + default("sequencerFeeVaultWithdrawalNetwork", "sequencerFeeVaultWithdrawalNetwork", 0);

local GovernanceDeployConfig =
  default("enableGovernance", "enableGovernance", false)
  + default("governanceTokenSymbol", "governanceTokenSymbol", "NA")
  + default("governanceTokenName", "governanceTokenName", "NotApplicable")
  + require("governanceTokenOwner", "ADMIN_ADDRESS");

local GasPriceOracleDeployConfig =
  default("gasPriceOracleOverhead", "gasPriceOracleOverhead", 2100)
  + default("gasPriceOracleScalar", "gasPriceOracleScalar", 1000000)
  + default("gasPriceOracleBaseFeeScalar", "gasPriceOracleBaseFeeScalar", 1368)
  + default("gasPriceOracleBlobBaseFeeScalar", "gasPriceOracleBlobBaseFeeScalar", 810949);

local GasTokenDeployConfig =
  default("useCustomGasToken", "useCustomGasToken", false)
  + optional("customGasTokenAddress", "customGasTokenAddress");

local OperatorDeployConfig =
  require("p2pSequencerAddress", "SEQUENCER_ADDRESS")
  + require("batchSenderAddress", "BATCHER_ADDRESS");

local EIP1559DeployConfig =
  default("eip1559Elasticity", "eip1559Elasticity", 6)
  + default("eip1559Denominator", "eip1559Denominator", 50)
  + default("eip1559DenominatorCanyon", "eip1559DenominatorCanyon", 250);

local UpgradeScheduleDeployConfig =
  default("l2GenesisRegolithTimeOffset", "l2GenesisRegolithTimeOffset", "0x0")
  + default("l2GenesisCanyonTimeOffset", "l2GenesisCanyonTimeOffset", "0x0")
  + default("l2GenesisDeltaTimeOffset", "l2GenesisDeltaTimeOffset", "0x0")
  + default("l2GenesisEcotoneTimeOffset", "l2GenesisEcotoneTimeOffset", "0x0")
  + default("l2GenesisFjordTimeOffset", "l2GenesisFjordTimeOffset", "0x0")
  + default("l2GenesisGraniteTimeOffset", "l2GenesisGraniteTimeOffset", "0x0")
  + default("l2GenesisInteropTimeOffset", "l2GenesisInteropTimeOffset", "0x0")
  + default("useInterop", "useInterop", false);

local L2CoreDeployConfig =
  require("l1ChainID", "l1ChainID")
  + require("l2ChainID", "l2ChainID")
  + default("l2BlockTime", "l2BlockTime", 2)
  + default("finalizationPeriodSeconds", "finalizationPeriodSeconds", 12)
  + default("maxSequencerDrift", "maxSequencerDrift", 600)
  + default("sequencerWindowSize", "sequencerWindowSize", 3600)
  + default("channelTimeout", "channelTimeout", 300)
  + optional("channelTimeoutGranite", "channelTimeoutGranite")
  + default("batchInboxAddress", "batchInboxAddress", "0xff00000000000000000000000000000000000000")
  + default("systemConfigStartBlock", "systemConfigStartBlock", 0);

local AltDADeployConfig =
  default("useAltDA", "useAltDA", false)
  + default("daCommitmentType", "daCommitmentType", "KeccakCommitment")
  + default("daChallengeWindow", "daChallengeWindow", 16)
  + default("daResolveWindow", "daResolveWindow", 16)
  + default("daBondSize", "daBondSize", 1000000)
  + default("daResolverRefundPercentage", "daResolverRefundPercentage", 0);

local DevL1DeployConfig =
  default("l1BlockTime", "l1BlockTime", 12)
  + optional("l1GenesisBlockTimestamp", "l1GenesisBlockTimestamp")
  + optional("l1GenesisBlockNonce", "l1GenesisBlockNonce")
  + optional("l1GenesisBlockGasLimit", "l1GenesisBlockGasLimit")
  + optional("l1GenesisBlockDifficulty", "l1GenesisBlockDifficulty")
  + optional("l1GenesisBlockMixHash", "l1GenesisBlockMixHash")
  + optional("l1GenesisBlockCoinbase", "l1GenesisBlockCoinbase")
  + optional("l1GenesisBlockNumber", "l1GenesisBlockNumber")
  + optional("l1GenesisBlockGasUsed", "l1GenesisBlockGasUsed")
  + optional("l1GenesisBlockParentHash", "l1GenesisBlockParentHash")
  + optional("l1GenesisBlockBaseFeePerGas", "l1GenesisBlockBaseFeePerGas")
  + optional("l1GenesisBlockExcessBlobGas", "l1GenesisBlockExcessBlobGas")
  + optional("l1GenesisBlockblobGasUsed", "l1GenesisBlockblobGasUsed");

local SuperchainL1DeployConfig =
  require("superchainConfigGuardian", "ADMIN_ADDRESS")
  + default("requiredProtocolVersion", "requiredProtocolVersion", "0x0000000000000000000000000000000000000000000000000000000000000000")
  + default("recommendedProtocolVersion", "recommendedProtocolVersion", "0x0000000000000000000000000000000000000000000000000000000000000000");

local OutputOracleDeployConfig =
  default("l2OutputOracleSubmissionInterval", "l2OutputOracleSubmissionInterval", 1800)
  + require("l2OutputOracleStartingTimestamp", "TIMESTAMP")
  + default("l2OutputOracleStartingBlockNumber", "l2OutputOracleStartingBlockNumber", 0)
  + require("l2OutputOracleProposer", "PROPOSER_ADDRESS")
  + require("l2OutputOracleChallenger", "ADMIN_ADDRESS");

local FaultProofDeployConfig =
  default("useFaultProofs", "useFaultProofs", true)
  + default("faultGameAbsolutePrestate", "faultGameAbsolutePrestate", "0x0000000000000000000000000000000000000000000000000000000000000000")
  + default("faultGameMaxDepth", "faultGameMaxDepth", 73)
  + default("faultGameClockExtension", "faultGameClockExtension", 18000)
  + default("faultGameMaxClockDuration", "faultGameMaxClockDuration", 302400)
  + default("faultGameGenesisBlock", "faultGameGenesisBlock", 0)
  + default("faultGameGenesisOutputRoot", "faultGameGenesisOutputRoot", "0x0000000000000000000000000000000000000000000000000000000000000000")
  + default("faultGameSplitDepth", "faultGameSplitDepth", 30)
  + default("faultGameWithdrawalDelay", "faultGameWithdrawalDelay", 604800)
  + default("preimageOracleMinProposalSize", "preimageOracleMinProposalSize", 126000)
  + default("preimageOracleChallengePeriod", "preimageOracleChallengePeriod", 86400)
  + default("proofMaturityDelaySeconds", "proofMaturityDelaySeconds", 604800)
  + default("disputeGameFinalityDelaySeconds", "disputeGameFinalityDelaySeconds", 302400)
  + default("respectedGameType", "respectedGameType", 0);

//-----------------------------------------------------------------------//
// output

L1StartingBlockTag
+ DevDeployConfig
+ L2GenesisBlockDeployConfig
+ OwnershipDeployConfig
+ L2VaultsDeployConfig
+ GovernanceDeployConfig
+ GasPriceOracleDeployConfig
+ GasTokenDeployConfig
+ OperatorDeployConfig
+ EIP1559DeployConfig
+ UpgradeScheduleDeployConfig
+ L2CoreDeployConfig
+ AltDADeployConfig
+ DevL1DeployConfig
+ SuperchainL1DeployConfig
+ OutputOracleDeployConfig
+ FaultProofDeployConfig
