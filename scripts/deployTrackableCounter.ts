import { toNano } from '@ton/core';
import { TrackableCounter } from '../build/TrackableCounter/TrackableCounter_TrackableCounter';
import { NetworkProvider } from '@ton/blueprint';

export async function run(provider: NetworkProvider) {
    const trackableCounter = provider.open(await TrackableCounter.fromInit(BigInt(Math.floor(Math.random() * 10000)), 0n));

    await trackableCounter.send(
        provider.sender(),
        {
            value: toNano('0.05'),
        },
        null,
    );

    await provider.waitForDeploy(trackableCounter.address);

    console.log('ID', await trackableCounter.getId());
}
