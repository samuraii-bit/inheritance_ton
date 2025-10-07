message Deploy {
    queryId: Int as uint64;   
}

message DeployOk {
    queryId: Int as uint64;
}

trait Deployable {
    receive(msg: Deploy) {
        send(SendParameters{
            to: sender(),
            value: 0,
            mode: SendRemainingValue + SendIgnoreErrors,
            body: DeployOk{queryId: msg.queryId}.toCell()
        });
    }
}

message Add {
    amount: Int as uint256;
}

contract DeployableCounter with Deployable  {
    // Empty receiver for the deployment,
    // which expects the `null` message body
    counter: Int as uint256 = 0;
    receive() {
        // Forward the remaining value in the
        // incoming message back to the sender
        // cashback(sender());
    }

    receive(msg: Add) {
        self.counter += msg.amount;

        // Forward the remaining value in the
        // incoming message back to the sender
        // cashback(sender());
    }

    get fun counter(): Int {
        return self.counter;
    }
}
