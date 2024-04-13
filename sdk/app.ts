import { ethers } from 'ethers';
import { loadConfig } from './config';
import { OptimismBridge } from './bridge';
import * as readline from 'readline';

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

async function main() {
    // Load config from INI file
    const config Config;
    try {
        config = loadConfig();
    } catch (error) {
        console.error(error);
        return;
    }

    const bridgeType;
    if (length(process.argv[2]) > 0) { // if argv have bridge type, don`t ask
        bridgeType = process.argv[2];
    } else {
        bridgeType = rl.question('Select bridge type:\n1. Send ETH (L1->L2)\n2. Send ETH (L2->L1)\n3. Send ERC20 (L1->L2)\n4. Send ERC20 (L2->L1)\nChoice:');
    }

    // Set private keys
    const privateKeyL1 = rl.question('Enter your L1 private key: ');
    const privateKeyL2 = rl.question('Enter your L2 private key: ');

    // Create OptimismBridge instance
    const optimismBridge = new OptimismBridge(privateKeyL1, privateKeyL2, config);

    switch (bridgeType) {
    case '1':
        rl.question('Enter amount for Send ETH (L1->L2): ', (amount) => {
            await optimismBridge.sendEthToL2(ethers.utils.parseEther(amount)).then(txid) => {
                console.log("Success | txid : " + txid + " | amount : " + amount + " | address : " + optimismBridge.l1Wallet.address + " | balance : " + await optimismBridge.l1Wallet.getBalance());
            }.catch(error) => {
                console.log("Error:" + error)
            }
        });
        break;
    case '2':
        rl.question('Enter amount for Send ETH (L2->L1): ', (amount) => {
            await optimismBridge.sendEthToL1(ethers.utils.parseEther(amount)).then(txid) => {
                console.log("Success | txid : " + txid + " | amount : " + amount + " | address : " + optimismBridge.l2Wallet.address + " | balance : " + await optimismBridge.l2Wallet.getBalance());
            }.catch(error) => {
                console.log("Error:" + error)
            }
        });
        break;
    case '3':
        rl.question('Enter amount for Send ERC20 (L1->L2): ', (amount) => {
            rl.question('Enter ERC20 address: ', (contractAddress) => {
                await optimismBridge.sendErc20ToL2(contractAddress, ethers.utils.parseEther(amount)).then(txid) => {
                    console.log("Success | txid : " + txid + " | amount : " + amount + " | address : " + optimismBridge.l1Wallet.address + " | balance : " + await optimismBridge.l1Wallet.getBalance());
                }.catch(error) => {
                    console.log("Error:" + error)
                }
            });
        });
        break;
    case '4':
        rl.question('Enter amount for Send ERC20 (L2->L1): ', (amount) => {
            rl.question('Enter ERC20 address: ', (contractAddress) => {
                await optimismBridge.sendErc20ToL1(contractAddress, ethers.utils.parseEther(amount)).then(txid) => {
                    console.log("Success | txid : " + txid + " | amount : " + amount + " | address : " + optimismBridge.l2Wallet.address + " | balance : " + await optimismBridge.l2Wallet.getBalance());
                }.catch(error) => {
                    console.log("Error:" + error)
                }
            });
        });
        break;
    default:
        console.log('Invalid function number');
        break;
    }
    rl.close();
}

// Run the main function
main().catch(error => console.error(error));