const { ethers } = require('ethers');
const { CrossChainMessenger, MessageStatus } = require('@eth-optimism/sdk');

class OptimismBridge {
    constructor(config) {
        this.config = config;     
    }

    async initialize() {
        const { l1ProviderUrl, l2ProviderUrl, AddressManager, L1CrossDomainMessenger, L1StandardBridge, OptimismPortal, L2OutputOracle } = this.config;
        this.l1Provider = new ethers.providers.StaticJsonRpcProvider(l1ProviderUrl);
        this.l2Provider = new ethers.providers.StaticJsonRpcProvider(l2ProviderUrl);
        const [l1Network, l2Network] = await Promise.all([this.l1Provider.getNetwork(), this.l2Provider.getNetwork()]);
        this.l1ChainId = l1Network.chainId;
        this.l2ChainId = l2Network.chainId;

        this.messenger = new CrossChainMessenger({
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
    }

    async validPrivateKey(privateKey) {
        return new ethers.Wallet(privateKey).address;
    }

    async sendEthToL2(fromPrivKeyL1, toAddressL2, toAmount) {
        const l1Wallet = new ethers.Wallet(fromPrivKeyL1, this.l1Provider);
        const balance = await l1Wallet.getBalance();
        if (balance.lt(toAmount)) {
            throw new Error('Insufficient balance | balance :' + balance.toString());
        }

        const crossBridge = new CrossChainMessenger({
            l1ChainId: this.l1ChainId,
            l2ChainId: this.l2ChainId,
            l1SignerOrProvider: l1Wallet,
            l2SignerOrProvider: this.l2Provider,
        });
        const tx = await crossBridge.depositETH(toAmount, { recipient: toAddressL2 });
        await tx.wait();
        await this.messenger.waitForMessageStatus(tx.hash, MessageStatus.RELAYED);
        return tx.hash;
    }

    async sendEthToL1(fromPrivKeyL2, toAddressL1, amount) {
        const l2Wallet = new ethers.Wallet(fromPrivKeyL2, this.l2Provider);
        const balance = await l2Wallet.getBalance();
        if (balance.lt(amount)) {
            throw new Error('Insufficient balance | balance :' + balance.toString());
        }

        const crossBridge = new CrossChainMessenger({
            l1ChainId: this.l1ChainId,
            l2ChainId: this.l2ChainId,
            l1SignerOrProvider: this.l1Provider,
            l2SignerOrProvider: l2Wallet,
        });
        const tx = await crossBridge.withdrawETH(amount, { recipient: toAddressL1 });
        await tx.wait();
        await this.messenger.waitForMessageStatus(tx.hash, MessageStatus.RELAYED);
        return tx.hash;
    }

    async getEthBalanceL1(addressL1) {
        return await this.l1Provider.getBalance(addressL1);
    }

    async getEthBalanceL2(addressL2) {
        return await this.l2Provider.getBalance(addressL2);
    }
    
    // todo
    /* 
        async sendErc20ToL2(fromPrivKeyL1, toAddressL2, tokenAddress, amount) {
            const l1Wallet = new ethers.Wallet(fromPrivKeyL1, this.l1Provider);
            const crossBridge = new CrossChainMessenger({
                l1ChainId: this.l1ChainId,
                l2ChainId: this.l2ChainId,
                l1SignerOrProvider: l1Wallet,
                l2SignerOrProvider: this.l2Provider,
            });
            const token = new ethers.Contract(tokenAddress, ['function approve(address spender, uint256 amount)'], this.l1Wallet);
            
        }

        async sendErc20ToL1(tokenAddress, amount) {
            const tx = await this.crossBridge.withdrawERC20(tokenAddress, amount);
            await tx.wait();
            await this.messenger.waitForMessageStatus(tx.hash, MessageStatus.RELAYED);
        }

        async getErc20BalanceL1(tokenAddress) {
            const token = new ethers.Contract(tokenAddress, ['function balanceOf(address)'], this.l1Wallet);
            return await token.balanceOf(this.l1Wallet.address);
        }

        async getErc20BalanceL2(tokenAddress) {
            const token = new ethers.Contract(tokenAddress, ['function balanceOf(address)'], this.l2Wallet);
            return await token.balanceOf(this.l2Wallet.address);
        }
    */
}

module.exports = {
    OptimismBridge: OptimismBridge
};