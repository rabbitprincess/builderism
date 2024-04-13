const { ethers } = require('ethers');
const { loadConfig } = require('./config');
const { OptimismBridge } = require('./bridge');
const readline = require('readline');

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

async function main() {
    let config;
    try {
        config = loadConfig();
    } catch (error) {
        throw new Error(error);
    }

    let bridgeType;
    if (process.argv[2]) { // if argv have bridge type, don`t ask
        bridgeType = process.argv[2];
    } else {
        bridgeType = await new Promise((resolve) => {
            rl.question('Select bridge type:\n\t1. Send ETH (L1->L2)\n\t2. Send ETH (L2->L1)\n\t3. Send ERC20 (L1->L2)\n\t4. Send ERC20 (L2->L1)\nChoice: ', (input) => {
                resolve(input);
            });
        });
    }

    const privateKeyL1 = await new Promise((resolve) => {
        rl.question('Enter your L1 private key: ', (input) => {
            resolve(input);
        });
    });

    const privateKeyL2 = await new Promise((resolve) => {
        rl.question('Enter your L2 private key: ', (input) => {
            resolve(input);
        });
    });

    const optimismBridge = new OptimismBridge(privateKeyL1, privateKeyL2, config);

    switch (bridgeType) {
        case '1':
            await new Promise((resolve) => {
                rl.question('Enter amount for Send ETH (L1->L2): ', async (amount) => {
                    try {
                        const txid = await optimismBridge.sendEthToL2(ethers.utils.parseEther(amount));
                        console.log("Success | txid : " + txid + " | amount : " + amount + " | address : " + optimismBridge.l1Wallet.address + " | balance : " + await optimismBridge.l1Wallet.getBalance());
                    } catch (error) {
                        console.log("Error:" + error);
                    }
                    resolve();
                });
            });
            break;
        case '2':
            await new Promise((resolve) => {
                rl.question('Enter amount for Send ETH (L2->L1): ', async (amount) => {
                    try {
                        const txid = await optimismBridge.sendEthToL1(ethers.utils.parseEther(amount));
                        console.log("Success | txid : " + txid + " | amount : " + amount + " | address : " + optimismBridge.l2Wallet.address + " | balance : " + await optimismBridge.l2Wallet.getBalance());
                    } catch (error) {
                        console.log("Error:" + error);
                    }
                    resolve();
                });
            });
            break;
        case '3':
            await new Promise((resolve) => {
                rl.question('Enter amount for Send ERC20 (L1->L2): ', async (amount) => {
                    rl.question('Enter ERC20 address: ', async (contractAddress) => {
                        try {
                            const txid = await optimismBridge.sendErc20ToL2(contractAddress, ethers.utils.parseEther(amount));
                            console.log("Success | txid : " + txid + " | amount : " + amount + " | address : " + optimismBridge.l1Wallet.address + " | balance : " + await optimismBridge.l1Wallet.getBalance());
                        } catch (error) {
                            console.log("Error:" + error);
                        }
                        resolve();
                    });
                });
            });
            break;
        case '4':
            await new Promise((resolve) => {
                rl.question('Enter amount for Send ERC20 (L2->L1): ', async (amount) => {
                    rl.question('Enter ERC20 address: ', async (contractAddress) => {
                        try {
                            const txid = await optimismBridge.sendErc20ToL1(contractAddress, ethers.utils.parseEther(amount));
                            console.log("Success | txid : " + txid + " | amount : " + amount + " | address : " + optimismBridge.l2Wallet.address + " | balance : " + await optimismBridge.l2Wallet.getBalance());
                        } catch (error) {
                            console.log("Error:" + error);
                        }
                        resolve();
                    });
                });
            });
            break;
        default:
            console.log('Invalid function number');
            break;
    }
    rl.close();
}

main().catch(error => function () {
    console.error(error);
    process.exit(1);
})
