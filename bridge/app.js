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
        throw error;
    }

    let bridgeType = process.argv[2];
    if (!bridgeType) {
        bridgeType = await question('Select bridge type:\n  1. Send ETH (L1->L2)\n  2. Send ETH (L2->L1)\n  3. Send ERC20 (L1->L2)\n  4. Send ERC20 (L2->L1)\nChoice: ');
    }

    let optimismBridge;
    try {
        optimismBridge = new OptimismBridge(config);
        await optimismBridge.initialize();
    } catch (error) {
        throw error;
    }

    try {
        switch (bridgeType) {
            case '1':
                {
                    const fromPrivateKeyL1 = await question('Enter L1 private key: ');
                    const toAddressL2 = await question('Enter L2 address: ');
                    const amount = await question('Enter amount for Send ETH (L1->L2): ');
                    const txid = await optimismBridge.sendEthToL2(fromPrivateKeyL1, toAddressL2, ethers.utils.parseEther(amount));
                    console.log(`Success | txid : ${txid} | amount : ${amount}`);
                    break;
                }
            case '2':
                {
                    const fromPrivateKeyL2 = await question('Enter L2 private key: ');
                    const toAddressL1 = await question('Enter L1 address: ');
                    const amount = await question('Enter amount for Send ETH (L2->L1): ');
                    const txid = await optimismBridge.sendEthToL1(fromPrivateKeyL2, toAddressL1, ethers.utils.parseEther(amount));
                    console.log(`Success | txid : ${txid} | amount : ${amount}`);
                    break;
                }
                /* // todo
            case '3':
                {
                    const amount = await question('Enter amount for Send ERC20 (L1->L2): ');
                    const contractAddress = await question('Enter ERC20 address: ');
                    const txid = await optimismBridge.sendErc20ToL2(contractAddress, ethers.utils.parseEther(amount));
                    console.log(`Success | txid : ${txid} | contract : ${contractAddress} | amount : ${amount}`);
                    break;
                }
            case '4':
                {
                    const amount = await question('Enter amount for Send ERC20 (L2->L1): ');
                    const contractAddress = await question('Enter ERC20 address: ');
                    const txid = await optimismBridge.sendErc20ToL1(contractAddress, ethers.utils.parseEther(amount));
                    console.log(`Success | txid : ${txid} | contract : ${contractAddress} | amount : ${amount}`);
                    break;
                }
                */
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
