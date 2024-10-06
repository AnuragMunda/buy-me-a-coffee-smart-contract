//SPDX-License-Identifier: MIT

// contracts/BuyMeACoffee.sol
pragma solidity 0.8.27;

// Contract Address on sepolia: 0xDBa03676a2fBb6711CB652beF5B7416A53c1421D

contract BuyMeACoffee {
    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/
    error AmountCannotBeLessOrEqualToZero();
    error TransactionFailed();
    error OnlyOwner();

    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    struct Memo {
        address from;
        uint256 timestamp;
        string name;
        string message;
    }

    // Address of contract deployer. Marked payable so that
    // we can withdraw to this address later.
    address payable public s_owner;

    // List of all memos received from coffee purchases.
    Memo[] s_memos;

    /*//////////////////////////////////////////////////////////////
                            EVENTS
    //////////////////////////////////////////////////////////////*/
    // Event to emit when a Memo is created.
    event NewMemo(address indexed from, uint256 timestamp, string name, string message);

    /*//////////////////////////////////////////////////////////////
                            FUNCTION MODIFIERS
    //////////////////////////////////////////////////////////////*/
    modifier onlyOwner() {
        require(msg.sender == s_owner, OnlyOwner());
        _;
    }

    /*//////////////////////////////////////////////////////////////
                            FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    constructor() {
        // Store the address of the deployer as a payable address.
        // When we withdraw funds, we'll withdraw here.
        s_owner = payable(msg.sender);
    }

    /* EXTERNAL FUNCTIONS */

    /**
     * @dev buy a coffee for owner (sends an ETH tip and leaves a memo)
     * @param _name name of the coffee purchaser
     * @param _message a nice message from the purchaser
     */
    function buyCoffee(string calldata _name, string calldata _message) external payable {
        // Must accept more than 0 ETH for a coffee.
        require(msg.value > 0, AmountCannotBeLessOrEqualToZero());

        // Add the memo to storage!
        s_memos.push(Memo(msg.sender, block.timestamp, _name, _message));

        // Emit a NewMemo event with details about the memo.
        emit NewMemo(msg.sender, block.timestamp, _name, _message);
    }

    /**
     * @dev send the entire balance stored in this contract to the owner
     */
    function withdrawTips() external onlyOwner {
        (bool success,) = s_owner.call{value: address(this).balance}("");
        require(success, TransactionFailed());
    }

    /* VIEW AND PURE FUNCTIONS */

    /**
     * @dev fetches all stored memos
     */
    function getMemos() public view returns (Memo[] memory) {
        return s_memos;
    }
}
