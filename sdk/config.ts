import fs from 'fs';
import dotenv from 'dotenv';
import ini from 'ini';

export interface Config {
    l1ProviderUrl: string;
    l2ProviderUrl: string;
    AddressManager: string;
    L1CrossDomainMessenger: string;
    L1StandardBridge: string;
    OptimismPortal: string;
    L2OutputOracle: string;
}

export function loadConfig(): Config {
    // read .env file in current folder
    env = dotenv.config({ path: '.env' }).parsed;
    // parse addresses from env.CONFIG_PATH
    if (!env.CONFIG_PATH) {
        throw new Error('CONFIG_PATH is not set');
    }
    const addresses = ini.parse(fs.readFileSync(env.CONFIG_PATH+'/address.env', 'utf-8'));
    if (!addresses) {
        throw new Error('invalid address.env file');
    }

    return {
        l1ProviderUrl: env.L1_RPC_URL,
        l2ProviderUrl: env.L2_RPC_URL,
        AddressManager: addresses.AddressManager,
        L1CrossDomainMessenger: addresses.L1CrossDomainMessenger,
        L1StandardBridge: addresses.L1StandardBridge,
        OptimismPortal: addresses.OptimismPortal,
        L2OutputOracle: addresses.L2OutputOracle,
    };
}