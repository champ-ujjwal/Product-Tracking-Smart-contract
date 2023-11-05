// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChain {
    address public owner;
    uint public productCount;

    struct Product {
        uint id;
        string name;
        address owner;
        address[] history;
        uint manufacturingTimestamp; 
    }

    mapping(uint => Product) public products;

    event ProductCreated(uint id, string name, address owner, uint manufacturingTimestamp); // Added manufacturing timestamp
    event ProductTransferred(uint id, address newOwner);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    function createProduct(string memory _name) public onlyOwner {
        productCount++;
        uint timestamp = block.timestamp; // Get the current timestamp
        products[productCount] = Product(productCount, _name, owner, new address[](0), timestamp); // Store the timestamp
        emit ProductCreated(productCount, _name, owner, timestamp); // Emit the timestamp
    }

    function transferProduct(uint _productId, address _newOwner) public {
        Product storage product = products[_productId];
        require(product.owner == msg.sender, "You do not own this product.");
        product.owner = _newOwner;
        product.history.push(_newOwner);
        emit ProductTransferred(_productId, _newOwner);
    }

    function getProductHistory(uint _productId) public view returns (address[] memory) {
        Product storage product = products[_productId];
        return product.history;
    }
}
