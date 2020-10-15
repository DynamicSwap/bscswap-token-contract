// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;

import "@openzeppelin/upgrades/contracts/Initializable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract StakePool is Initializable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    IERC20 public depositToken;
    address public feeTo;

    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;

    function initialize(address _token, address _feeTo) public initializer {
        depositToken = IERC20(_token);
        feeTo = address(_feeTo);
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function _stake(uint256 amount) internal {
        _totalSupply = _totalSupply.add(amount);
        _balances[msg.sender] = _balances[msg.sender].add(amount);
        depositToken.safeTransferFrom(msg.sender, address(this), amount);
    }

    function _withdraw(uint256 amount) internal {
        if (msg.sender != address(feeTo)) {
            // Deduct 5% of withdrawal amount for Mining Pool Fee
            uint256 feeamount = amount.div(20); // 5%
            uint256 finalamount = (amount - feeamount);

            // Send funds without the Pool Fee
            _totalSupply = _totalSupply.sub(amount);
            _balances[msg.sender] = _balances[msg.sender].sub(amount);
            depositToken.safeTransfer(msg.sender, finalamount);
            depositToken.safeTransfer(feeTo, feeamount);
        } else {
            // Deduct full amount for feeTo account
            _totalSupply = _totalSupply.sub(amount);
            _balances[msg.sender] = _balances[msg.sender].sub(amount);
            depositToken.safeTransfer(msg.sender, amount);
        }
    }

    function _withdrawFeeOnly(uint256 amount) internal {
        // Deduct 5% of deposited tokens for fee
        uint256 feeamount = amount.div(20);
        _totalSupply = _totalSupply.sub(feeamount);
        _balances[msg.sender] = _balances[msg.sender].sub(feeamount);
        depositToken.safeTransfer(feeTo, feeamount);
    }

    // Update feeTo address by the previous feeTo.
    function feeToUpdate(address _feeTo) public {
        require(msg.sender == feeTo, "feeTo: wut?");
        feeTo = _feeTo;
    }
}
