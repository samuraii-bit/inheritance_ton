import "./ownable_counter";

trait Trackable with OwnableTransferable {
    owner: Address;
    numMessagesReceived: Int as uint256;
    virtual const ENABLE_RESET: Bool = true;

    fun receiveMessage() {
        if (self.filterMessage()) {
            self.numMessagesReceived += 1;
        }
    }

    get fun stats(): Int {
        return self.numMessagesReceived;
    }

    receive("reset stats") {
        if (self.ENABLE_RESET) {
            self.onlyOwner();
            self.numMessagesReceived = 0;
            send(SendParameters {
                to: sender(),
                value: 0,
                mode: SendRemainingValue + SendIgnoreErrors,
                body: "stats reseted".asComment()
            })
        }
    }

    virtual fun filterMessage(): Bool {
        if (sender() == self.owner) {
            return false;
        }
        return true;
    }
}

contract TrackableCounter with Trackable {
    owner: Address;
    numMessagesReceived: Int as uint256;
    id: Int as uint256;
    counter: Int as uint256;
    override const ENABLE_RESET: Bool = false;
    init(id: Int) {
        self.id = id;
        self.counter = 0;
        self.numMessagesReceived = 0;
        self.owner = sender();
    }

    // Empty receiver for the deployment,
    // which expects the `null` message body
    receive() {
        // Forward the remaining value in the
        // incoming message back to the sender
        // cashback(sender());
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

    override fun filterMessage(): Bool {
        return true;
    }
}
