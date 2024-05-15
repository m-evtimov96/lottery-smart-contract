// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

contract Lottery {

    address public owner;
    address payable[] private players;
    uint public lotteryId;

    mapping (uint => address payable) private lotteryHistory;

    modifier onlyOwner() {
        require(msg.sender == owner, "Sender not authorized.");
        _;
    }

    constructor() {
        owner = msg.sender;
        lotteryId = 1;
    }

    function getWinnerByLotteryId(uint lottery) public view returns (address payable) {
        return lotteryHistory[lottery];
    }

    function getBalance() public onlyOwner view returns (uint) {
        return address(this).balance;
    }

    function getPlayers() public onlyOwner view returns (address payable[] memory) {
        return players;
    }

    function getNumPlayers() public view returns (uint count) {
        return players.length;
    }

    function enter() public payable {
        //Require more than .005 eth to enter lottery
        require(msg.value > .005 ether);

        players.push(payable(msg.sender));
    }

    function getRandomNumber() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    function pickWinner() public onlyOwner {
        uint index = getRandomNumber() % players.length;
        players[index].transfer(address(this).balance);

        //Save winner and lot.id data to lotteryHistory and reset lottery state
        lotteryHistory[lotteryId] = players[index];
        lotteryId++;
        players = new address payable[](0);
    }

}