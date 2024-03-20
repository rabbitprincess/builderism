// config.ts

import fs from 'fs';
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

export function loadConfigFromIni(filePath: string): Config {
    const configData = ini.parse(fs.readFileSync(filePath, 'utf-8'));
    return {
        l1ProviderUrl: configData.l1ProviderUrl,
        l2ProviderUrl: configData.l2ProviderUrl,
        AddressManager: configData.AddressManager,
        L1CrossDomainMessenger: configData.L1CrossDomainMessenger,
        L1StandardBridge: configData.L1StandardBridge,
        OptimismPortal: configData.OptimismPortal,
        L2OutputOracle: configData.L2OutputOracle,
    };
}