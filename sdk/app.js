const { ethers } = require('ethers');
const { loadConfig } = require('./config');
const { OptimismBridge } = require('./bridge');
const { createInterface } = require('readline');

const rl = createInterface({
    input: process.stdin,
    output: process.stdout
});

function question(prompt) {
    return new Promise((resolve) => {
        rl.question(prompt, (input) => {
            resolve(input);
        });
    });
}

async function main() {
    let config;
    try {
        config = loadConfig();
    } catch (error) {
        throw new Error(error);
    }

    let bridgeType = process.argv[2];
    if (!bridgeType) {
        bridgeType = await question('Select bridge type:\n  1. Send ETH (L1->L2)\n  2. Send ETH (L2->L1)\n  3. Send ERC20 (L1->L2)\n  4. Send ERC20 (L2->L1)\nChoice: ');
    }
    const privateKeyL1 = await question('Enter your L1 private key: ');
    const privateKeyL2 = await question('Enter your L2 private key: ');

    let optimismBridge;
    try {
        optimismBridge = new OptimismBridge(privateKeyL1, privateKeyL2, config);
    } catch (error) {
        throw new Error(error);
    }

    try {
        switch (bridgeType) {
            case '1':
                {
                    const amount = await question('Enter amount for Send ETH (L1->L2): ');
                    const txid = await optimismBridge.sendEthToL2(ethers.utils.parseEther(amount));
                    console.log(`Success | txid : ${txid} | amount : ${amount} | address : ${optimismBridge.l1Wallet.address} | balance : ${await optimismBridge.l1Wallet.getBalance()}`);
                    break;
                }
            case '2':
                {
                    const amount = await question('Enter amount for Send ETH (L2->L1): ');
                    const txid = await optimismBridge.sendEthToL1(ethers.utils.parseEther(amount));
                    console.log(`Success | txid : ${txid} | amount : ${amount} | address : ${optimismBridge.l2Wallet.address} | balance : ${await optimismBridge.l2Wallet.getBalance()}`);
                    break;
                }
            case '3':
                {
                    const amount = await question('Enter amount for Send ERC20 (L1->L2): ');
                    const contractAddress = await question('Enter ERC20 address: ');
                    const txid = await optimismBridge.sendErc20ToL2(contractAddress, ethers.utils.parseEther(amount));
                    console.log(`Success | txid : ${txid} | amount : ${amount} | address : ${optimismBridge.l1Wallet.address} | balance : ${await optimismBridge.l1Wallet.getBalance()}`);
                    break;
                }
            case '4':
                {
                    const amount = await question('Enter amount for Send ERC20 (L2->L1): ');
                    const contractAddress = await question('Enter ERC20 address: ');
                    const txid = await optimismBridge.sendErc20ToL1(contractAddress, ethers.utils.parseEther(amount));
                    console.log(`Success | txid : ${txid} | amount : ${amount} | address : ${optimismBridge.l2Wallet.address} | balance : ${await optimismBridge.l2Wallet.getBalance()}`);
                    break;
                }
            default:
                console.log('Invalid function number');
                break;
        }
    } catch (error) {
        console.error('Error:', error);
    } finally {
        rl.close();
    }
}

main().catch(error => function () {
    console.error(error);
    process.exit(1);
})
