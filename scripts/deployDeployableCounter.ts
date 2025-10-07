import { toNano } from '@ton/core';
import { DeployableCounter } from '../build/DeployableCounter/DeployableCounter_DeployableCounter';
import { NetworkProvider } from '@ton/blueprint';

export async function run(provider: NetworkProvider) {
    const deployableCounter = provider.open(await DeployableCounter.fromInit(BigInt(Math.floor(Math.random() * 10000)), 0n));

    await deployableCounter.send(
        provider.sender(),
        {
            value: toNano('0.05'),
        },
        null,
    );

    await provider.waitForDeploy(deployableCounter.address);

    console.log('ID', await deployableCounter.getId());
}
