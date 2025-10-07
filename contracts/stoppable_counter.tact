import "./ownable_counter";

trait Stoppable with OwnableTransferable{
    owner: Address;
    stopped: Bool;

    get fun stopped(): Bool {
        return self.stopped;
    }

    receive("stop") {
        self.onlyOwner();
        self.stopped = true;
        send(SendParameters {
            to: sender(),
            value: 0,
            mode: SendRemainingValue + SendIgnoreErrors,
            body: "stopped".asComment()
        });
    }

    fun requireNotStopped() {
        require(!self.stopped, "contract stopped");
    }

    fun requireStopped() {
        require(self.stopped, "contract not stopped")
    }
}

trait Resumable with Stoppable {
    owner: Address;
    stopped: Bool;

    receive("resume") {
        self.onlyOwner();
        self.requireStopped();
        self.stopped = false;
        send(SendParameters {
            to: sender(),
            value: 0,
            mode: SendRemainingValue + SendIgnoreErrors,
            body: "resumed".asComment()
        });
    }
}

contract StoppableCounter with Resumable{
    owner: Address;
    stopped: Bool;
    counter: Int as uint256;
    id: Int as uint256;

    init(id: Int) {
        self.counter = 0;
        self.id = id;
        self.owner = sender();
        self.stopped = false;
    }
    // Empty receiver for the deployment,
    // which expects the `null` message body
    receive() {
        // Forward the remaining value in the
        // incoming message back to the sender
        cashback(sender());
    }

    receive(msg: Add) {
        self.counter += msg.amount;

        // Forward the remaining value in the
        // incoming message back to the sender
        cashback(sender());
    }

    get fun counter(): Int {
        return self.counter;
    }

    get fun id(): Int {
        return self.id;
    }
}
