import { ethers } from 'ethers';
import optimism_sdk from '@eth-optimism/sdk';
import { Config } from './config';

export class OptimismBridge {
    private l1Provider: ethers.providers.StaticJsonRpcProvider;
    private l2Provider: ethers.providers.StaticJsonRpcProvider;
    private l1ChainId: Promise<number>;
    private l2ChainId: Promise<number>;
    private l1Wallet: ethers.Wallet;
    private l2Wallet: ethers.Wallet;
    private messanger: optimism_sdk.CrossChainMessenger;
    private crossBridge: optimism_sdk.CrossChainMessenger;

    constructor(privateKeyL1: string, privateKeyL2: string, config: Config) {
        const { l1ProviderUrl, l2ProviderUrl, AddressManager, L1CrossDomainMessenger, L1StandardBridge, OptimismPortal, L2OutputOracle } = config;

        this.l1Provider = new ethers.providers.StaticJsonRpcProvider(l1ProviderUrl);
        this.l2Provider = new ethers.providers.StaticJsonRpcProvider(l2ProviderUrl);
        this.l1ChainId = this.l1Provider.getNetwork().then(network => network.chainId);
        this.l2ChainId = this.l2Provider.getNetwork().then(network => network.chainId);

        this.l1Wallet = new ethers.Wallet(privateKeyL1, this.l1Provider);
        this.l2Wallet = new ethers.Wallet(privateKeyL2, this.l2Provider);

        this.messanger = new optimism_sdk.CrossChainMessenger({
            l1SignerOrProvider: this.l1Provider,
            l2SignerOrProvider: this.l2Provider,
            l1ChainId: this.l1ChainId,
            l2ChainId: this.l2ChainId,
            contracts: {
                l1: {
                    AddressManager,
                    L1CrossDomainMessenger,
                    L1StandardBridge,
                    OptimismPortal,
                    L2OutputOracle,
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