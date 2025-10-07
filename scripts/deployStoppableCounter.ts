import { toNano } from '@ton/core';
import { StoppableCounter } from '../build/StoppableCounter/StoppableCounter_StoppableCounter';
import { NetworkProvider } from '@ton/blueprint';

export async function run(provider: NetworkProvider) {
    const stoppableCounter = provider.open(await StoppableCounter.fromInit(BigInt(Math.floor(Math.random() * 10000)), 0n));

    await stoppableCounter.send(
        provider.sender(),
        {
            value: toNano('0.05'),
        },
        null,
    );

    await provider.waitForDeploy(stoppableCounter.address);

    console.log('ID', await stoppableCounter.getId());
}
