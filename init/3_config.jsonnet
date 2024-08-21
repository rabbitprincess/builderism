//-----------------------------------------------------------------------//
// args and funcs

local config = std.extVar("config");

local require(key, conf) =
  if std.objectHas(config, conf) then
    { [key]: config[conf] }
  else
    error "required field not found :" + conf;

local default(key, conf, default) =
  if std.objectHas(config, conf) then
    { [key]: config[conf] }
  else
    { [key]: default };

local optional(key, conf) =
  if std.objectHas(config, conf) then
    { [key]: config[conf] }
  else
    {};

//-----------------------------------------------------------------------//
// elements

local DevDeployConfig =
  default("fundDevAccounts", "fundDevAccounts", false);

local L2GenesisBlockDeployConfig =
  default("l2GenesisBlockNonce", "l2GenesisBlockNonce", 0)
  + default("l2GenesisBlockGasLimit", "l2GenesisBlockGasLimit", "0x1c9c380") // 30_000_000
  + default("l2GenesisBlockDifficulty", "l2GenesisBlockDifficulty", "0x0")
  + default("l2GenesisBlockMixHash", "l2GenesisBlockMixHash", "0x0000000000000000000000000000000000000000000000000000000000000000")
  + default("l2GenesisBlockNumber", "l2GenesisBlockNumber", 0)
  + default("l2GenesisBlockGasUsed", "l2GenesisBlockGasUsed", 0)
  + default("l2GenesisBlockParentHash", "l2GenesisBlockParentHash", "0x0000000000000000000000000000000000000000000000000000000000000000")
  + default("l2GenesisBlockBaseFeePerGas", "l2GenesisBlockBaseFeePerGas", "0x3b9aca00") // 1_000_000_000
  + default("l2GenesisBlockExtraData", "l2GenesisBlockExtraData", "0x426544524f434b");

local OwnershipDeployConfig =
  require("proxyAdminOwner", "ADMIN_ADDRESS")
  + require("finalSystemOwner", "ADMIN_ADDRESS");

local L2VaultsDeployConfig =
  default("baseFeeVaultRecipient", "ADMIN_ADDRESS", "0x0000000000000000000000000000000000000000")
  + default("l1FeeVaultRecipient", "ADMIN_ADDRESS", "0x0000000000000000000000000000000000000000")
  + default("sequencerFeeVaultRecipient", "ADMIN_ADDRESS", "0x0000000000000000000000000000000000000000")
  + default("baseFeeVaultMinimumWithdrawalAmount", "baseFeeVaultMinimumWithdrawalAmount", "0x8ac7230489e80000")
  + default("l1FeeVaultMinimumWithdrawalAmount", "l1FeeVaultMinimumWithdrawalAmount", "0x8ac7230489e80000")
  + default("sequencerFeeVaultMinimumWithdrawalAmount", "sequencerFeeVaultMinimumWithdrawalAmount", "0x8ac7230489e80000")
  + default("baseFeeVaultWithdrawalNetwork", "baseFeeVaultWithdrawalNetwork", 0)
  + default("l1FeeVaultWithdrawalNetwork", "l1FeeVaultWithdrawalNetwork", 0)
  + default("sequencerFeeVaultWithdrawalNetwork", "sequencerFeeVaultWithdrawalNetwork", 0);

local GovConfig =
  default("enableGovernance", "enableGovernance", false)
  + default("governanceTokenSymbol", "governanceTokenSymbol", "NA")
  + default("governanceTokenName", "governanceTokenName", "NotApplicable")
  + optional("governanceTokenOwner", "governanceTokenOwner");

local GasPriceOracleDeployConfig =
  default("gasPriceOracleOverhead", "gasPriceOracleOverhead", 2100)
  + default("gasPriceOracleScalar", "gasPriceOracleScalar", 1000000)
  + default("gasPriceOracleBaseFeeScalar", "gasPriceOracleBaseFeeScalar", 1368)
  + default("gasPriceOracleBlobBaseFeeScalar", "gasPriceOracleBlobBaseFeeScalar", 810949);

local GasTokenDeployConfig =
  default("useCustomGasToken", "useCustomGasToken", false)
  + optional("customGasTokenAddress", "customGasTokenAddress");

// OperatorDeployConfig
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
  + require("l2BlockTime", "l2BlockTime")
  + default("finalizationPeriodSeconds", "finalizationPeriodSeconds", 12)
  + default("maxSequencerDrift", "maxSequencerDrift", 600)
  + default("sequencerWindowSize", "sequencerWindowSize", 3600)
  + default("channelTimeoutBedrock", "channelTimeoutBedrock", 300)
  + default("channelTimeoutGranite", "channelTimeoutGranite", 0)
  + default("batchInboxAddress", "batchInboxAddress", "0xff00000000000000000000000000000000000000")
  + default("systemConfigStartBlock", "systemConfigStartBlock", 0);

local AltDaConfig =
  default("usePlasma", "usePlasma", false)
  + default("daCommitmentType", "daCommitmentType", "KeccakCommitment")
  + default("daChallengeWindow", "daChallengeWindow", 16)
  + default("daResolveWindow", "daResolveWindow", 16)
  + default("daBondSize", "daBondSize", 1000000)
  + default("daResolverRefundPercentage", "daResolverRefundPercentage", 0);

//-----------------------------------------------------------------------//
// output
# l1StartingBlockTag: blockhash

DevDeployConfig
+ L2GenesisBlockDeployConfig
+ OwnershipDeployConfig
+ L2VaultsDeployConfig
+ GovConfig
+ GasPriceOracleDeployConfig
+ GasTokenDeployConfig
+ OperatorDeployConfig
+ EIP1559DeployConfig
+ UpgradeScheduleDeployConfig
+ L2CoreDeployConfig
+ AltDaConfig
