import { toNano } from '@ton/core';
import { OwnableCounter } from '../build/OwnableCounter/OwnableCounter_OwnableCounter';
import { NetworkProvider } from '@ton/blueprint';

export async function run(provider: NetworkProvider) {
    const ownableCounter = provider.open(await OwnableCounter.fromInit(BigInt(Math.floor(Math.random() * 10000)), 0n));

    await ownableCounter.send(
        provider.sender(),
        {
            value: toNano('0.05'),
        },
        null,
    );

    await provider.waitForDeploy(ownableCounter.address);

    console.log('ID', await ownableCounter.getId());
}
