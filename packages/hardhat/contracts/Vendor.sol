pragma solidity 0.8.20; //Do not change the solidity version as it negatively impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
    YourToken public yourToken;
    uint256 public constant tokensPerEth = 100;

    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
    event SellTokens(address seller, uint256 amountOfETH, uint256 amountOfTokens);

    constructor(address tokenAddress) Ownable(msg.sender) {
        yourToken = YourToken(tokenAddress);
    }

    function buyTokens() external payable {
        require(msg.value > 0, "Send ETH to buy tokens");

        uint256 amountToBuy = (msg.value * tokensPerEth * 10 ** 18) / 1 ether;

        uint256 vendorBalance = yourToken.balanceOf(address(this));
        require(vendorBalance >= amountToBuy, "ERC20InsufficientBalance");

        yourToken.transfer(msg.sender, amountToBuy);

        emit BuyTokens(msg.sender, msg.value, amountToBuy);
    }

    function withdraw() external onlyOwner {
        uint256 ownerBalance = address(this).balance;
        require(ownerBalance > 0, "No ETH to withdraw");

        (bool sent, ) = msg.sender.call{ value: ownerBalance }("");
        require(sent, "Failed to send Ether");
    }

    function sellTokens(uint256 tokenAmountToSell) external {
        require(tokenAmountToSell > 0, "Specify an amount of token to sell");

        uint256 userBalance = yourToken.balanceOf(msg.sender);
        require(userBalance >= tokenAmountToSell, "Not enough token to sell");

        uint256 ethAmount = (tokenAmountToSell * 1 ether) / (tokensPerEth * 10 ** 18);
        require(address(this).balance >= ethAmount, "Vendor has not enough ETH");

        yourToken.transferFrom(msg.sender, address(this), tokenAmountToSell);

        (bool sent, ) = msg.sender.call{ value: ethAmount }("");
        require(sent, "Failed to send Ether");

        emit SellTokens(msg.sender, tokenAmountToSell, ethAmount);
    }
}
