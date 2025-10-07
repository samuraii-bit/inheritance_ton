trait Ownable {
    owner: Address;

    fun onlyOwner() {
        require(sender() == self.owner, "Only owner can use this function");
    }

    get fun owner(): Address {
        return self.owner;
    }
}

message ChangeOwner {
    newOwner: Address;
}

trait OwnableTransferable with Ownable {
    owner: Address;
    
    receive(msg: ChangeOwner) {
        self.onlyOwner();
        self.owner = msg.newOwner;
    }
}

message Add {
    amount: Int as uint256;
}

contract OwnableCounter with OwnableTransferable {
    owner: Address;
    counter: Int as uint32;
    id: Int as uint32;
    
    init(id: Int as uint32) {
        self.counter = 0;
        self.id = id;
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
        self.onlyOwner();
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
