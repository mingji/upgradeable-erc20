// SPDX-License-Identifier: MIT
pragma solidity 0.7.6;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract AcalaTokenImplementation is Initializable, ERC20Upgradeable, OwnableUpgradeable {
    using SafeMath for uint256;

    uint256 public price;

    function initialize(string memory _name, string memory _symbol) external initializer {
        __ERC20_init(_name, _symbol);
        __Ownable_init();
        price = 1;
    }

    function setPrice(uint256 _price) external onlyOwner {
        require(_price > 0 , 'Invalid Price');
        price = _price;
    }

    function mint() external payable {
        require(msg.value > 0 , 'Invalid Amount');
        uint256 amount = price.mul(msg.value);
        _mint(msg.sender, amount);
    }

    // This function is for the upgraded contract
    // function burn(uint256 amount) external {
    //     require(amount > 0 , 'Invalid Amount');
    //     require(balanceOf(msg.sender) >= amount , 'Insufficient Amount');
    //     _burn(msg.sender, amount);
    //     uint256 ethAmount = amount.mul(90).div(price).div(100);
    //     payable(msg.sender).transfer(ethAmount);
    // }

    uint256[49] private __gap;
}