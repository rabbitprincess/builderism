import { ethers } from 'ethers';
import { Config } from './config';
import { OptimismBridge } from './bridge';

async function main() {
    // Load config from INI file
    const configFilePath = 'config.ini';
    const config = loadConfigFromIni(configFilePath);

    // Set private keys
    const privateKeyL1 = 'YourPrivateKeyForL1';
    const privateKeyL2 = 'YourPrivateKeyForL2';

    // Create OptimismBridge instance
    const optimismBridge = new OptimismBridge(privateKeyL1, privateKeyL2, config);

    // Example usage
    console.log(await optimismBridge.getL1Balance()); // L1 balance
    await optimismBridge.depositToL2(ethers.utils.parseEther('0.002')); // Deposit from L1 to L2
    await optimismBridge.withdrawToL1(ethers.utils.parseEther('0.001')); // Withdraw from L2 to L1
}

// Run the main function
main().catch(error => console.error(error));