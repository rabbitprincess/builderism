import fs from 'fs';
import ini from 'ini';
import { ethers } from 'ethers';
import optimism_sdk from '@eth-optimism/sdk';
import config, { Config } from './config';

class OptimismBridge {
    private l1Provider: ethers.providers.StaticJsonRpcProvider;
    private l2Provider: ethers.providers.StaticJsonRpcProvider;
    private l1ChainId: Promise<number>;
    private l2ChainId: Promise<number>;
    private AddressManager: string;
    private L1CrossDomainMessenger: string;
    private L1StandardBridge: string;
    private OptimismPortal: string;
    private L2OutputOracle: string;
    private l1Wallet: ethers.Wallet;
    private l2Wallet: ethers.Wallet;
    private messanger: optimism_sdk.CrossChainMessenger;
    private crossBridge: optimism_sdk.CrossChainMessenger;

    constructor(privateKeyL1: string, privateKeyL2: string, config: Config) {
        this.l1Provider = new ethers.providers.StaticJsonRpcProvider(config.l1ProviderUrl);
        this.l2Provider = new ethers.providers.StaticJsonRpcProvider(config.l2ProviderUrl);
        this.l1ChainId = this.l1Provider.getNetwork().then(network => network.chainId);
        this.l2ChainId = this.l2Provider.getNetwork().then(network => network.chainId);

        this.AddressManager = config.AddressManager;
        this.L1CrossDomainMessenger = config.L1CrossDomainMessenger;
        this.L1StandardBridge = config.L1StandardBridge;
        this.OptimismPortal = config.OptimismPortal;
        this.L2OutputOracle = config.L2OutputOracle;

        this.l1Wallet = new ethers.Wallet(privateKeyL1, this.l1Provider);
        this.l2Wallet = new ethers.Wallet(privateKeyL2, this.l2Provider);

        this.messanger = new optimism_sdk.CrossChainMessenger({
            l1SignerOrProvider: this.l1Provider,
            l2SignerOrProvider: this.l2Provider,
            l1ChainId: this.l1ChainId,
            l2ChainId: this.l2ChainId,
            contracts: {
                l1: {
                    AddressManager: this.AddressManager,
                    L1CrossDomainMessenger: this.L1CrossDomainMessenger,
                    L1StandardBridge: this.L1StandardBridge,
                    OptimismPortal: this.OptimismPortal,
                    L2OutputOracle: this.L2OutputOracle,
                    StateCommitmentChain: ethers.constants.AddressZero,
                    CanonicalTransactionChain: ethers.constants.AddressZero,
                    BondManager: ethers.constants.AddressZero,
                }
            }
        });

        this.crossBridge = new optimism_sdk.CrossChainMessenger({
            l1ChainId: this.l1ChainId,
            l2ChainId: this.l2ChainId,
            l1SignerOrProvider: this.l1Wallet,
            l2SignerOrProvider: this.l2Wallet,
        });
    }

    async depositToL2(amount: ethers.BigNumberish) {
        const tx = await this.crossBridge.depositETH(amount);
        await tx.wait();
        await this.messanger.waitForMessageStatus(tx.hash, optimism_sdk.MessageStatus.RELAYED);
    }

    async withdrawToL1(amount: ethers.BigNumberish) {
        const tx = await this.crossBridge.withdrawETH(amount);
        await tx.wait();
        await this.messanger.waitForMessageStatus(tx.hash, optimism_sdk.MessageStatus.RELAYED);
    }

    async getL1Balance() {
        return await this.l1Wallet.getBalance();
    }
}
