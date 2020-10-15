// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// Bai Stablecoin Contract
contract BAI is ERC20("Bai Stablecoin", "BAI"), ERC20Burnable, Ownable {
    /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (Curve).
    function mint(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount);
    }
}
