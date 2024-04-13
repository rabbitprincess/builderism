const { ethers } = require('ethers');
const optimism_sdk = require('@eth-optimism/sdk');
const { Config } = require('./config');

class OptimismBridge {
    constructor(privateKeyL1, privateKeyL2, config) {
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

    async validPrivateKey(privateKey) {
        return new ethers.Wallet(privateKey).address;
    }

    async sendEthToL2(amount) {
        if (await this.l1Wallet.getBalance() < amount) {
            throw new Error('Insufficient balance L1 | address : ' + this.l1Wallet.address + ' | balance : ' + await this.l1Wallet.getBalance());
        }

        const tx = await this.crossBridge.depositETH(amount);
        await tx.wait();
        await this.messanger.waitForMessageStatus(tx.hash, optimism_sdk.MessageStatus.RELAYED);
        return tx.hash;
    }

    async sendEthToL1(amount) {
        const tx = await this.crossBridge.withdrawETH(amount);
        await tx.wait();
        await this.messanger.waitForMessageStatus(tx.hash, optimism_sdk.MessageStatus.RELAYED);
    }

    async getEthBalanceL1() {
        return await this.l1Wallet.getBalance();
    }

    async getEthBalanceL2() {
        return await this.l2Wallet.getBalance();
    }

    async sendErc20ToL2(tokenAddress, amount) {
        const token = new ethers.Contract(tokenAddress, ['function approve(address spender, uint256 amount)'], this.l1Wallet);
        await token.approve(this.crossBridge.contracts.l1.L1StandardBridge, amount);
        const tx = await this.crossBridge.depositERC20(tokenAddress, amount);
        await tx.wait();
        await this.messanger.waitForMessageStatus(tx.hash, optimism_sdk.MessageStatus.RELAYED);
    }

    async sendErc20ToL1(tokenAddress, amount) {
        const tx = await this.crossBridge.withdrawERC20(tokenAddress, amount);
        await tx.wait();
        await this.messanger.waitForMessageStatus(tx.hash, optimism_sdk.MessageStatus.RELAYED);
    }

    async getErc20BalanceL1(tokenAddress) {
        const token = new ethers.Contract(tokenAddress, ['function balanceOf(address)'], this.l1Wallet);
        return await token.balanceOf(this.l1Wallet.address);
    }

    async getErc20BalanceL2(tokenAddress) {
        const token = new ethers.Contract(tokenAddress, ['function balanceOf(address)'], this.l2Wallet);
        return await token.balanceOf(this.l2Wallet.address);
    }

    async sendErc721ToL2(tokenAddress, tokenId) {
        const tx = await this.crossBridge.depositERC721(tokenAddress, tokenId);
        await tx.wait();
        await this.messanger.waitForMessageStatus(tx.hash, optimism_sdk.MessageStatus.RELAYED);
    }

    async sendErc721ToL1(tokenAddress, tokenId) {
        const tx = await this.crossBridge.withdrawERC721(tokenAddress, tokenId);
        await tx.wait();
        await this.messanger.waitForMessageStatus(tx.hash, optimism_sdk.MessageStatus.RELAYED);
    }

    async getErc721OwnerL1(tokenAddress, tokenId) {
        const token = new ethers.Contract(tokenAddress, ['function ownerOf(uint256)'], this.l1Wallet);
        return await token.ownerOf(tokenId);
    }

    async getErc721OwnerL2(tokenAddress, tokenId) {
        const token = new ethers.Contract(tokenAddress, ['function ownerOf(uint256)'], this.l2Wallet);
        return await token.ownerOf(tokenId);
    }

    async sendErc1155ToL2(tokenAddress, tokenId, amount) {
        const tx = await this.crossBridge.depositERC1155(tokenAddress, tokenId, amount);
        await tx.wait();
        await this.messanger.waitForMessageStatus(tx.hash, optimism_sdk.MessageStatus.RELAYED);
    }

    async sendErc1155ToL1(tokenAddress, tokenId, amount) {
        const tx = await this.crossBridge.withdrawERC1155(tokenAddress, tokenId, amount);
        await tx.wait();
        await this.messanger.waitForMessageStatus(tx.hash, optimism_sdk.MessageStatus.RELAYED);
    }

    async getErc1155BalanceL1(tokenAddress, tokenId) {
        const token = new ethers.Contract(tokenAddress, ['function balanceOf(address,uint256)'], this.l1Wallet);
        return await token.balanceOf(this.l1Wallet.address, tokenId);
    }

    async getErc1155BalanceL2(tokenAddress, tokenId) {
        const token = new ethers.Contract(tokenAddress, ['function balanceOf(address,uint256)'], this.l2Wallet);
        return await token.balanceOf(this.l2Wallet.address, tokenId);
    }
}

module.exports = {
    OptimismBridge,
};