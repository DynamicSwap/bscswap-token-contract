// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;

import "@openzeppelin/contracts/math/Math.sol";
import "./StakePool.sol";

/**
 * @dev https://bscswap.com
 * Yield Token will be halved at each period.
 * Forked from https://github.com/cryptoghoulz/based-contracts/blob/master/contracts/v5/Pool1.sol and https://github.com/milk-protocol/stakecow-contracts-bsc/blob/master/contracts/FomoCow.sol
 */

 contract LaunchField is StakePool {
     // Yield Token as a reward for stakers
     IERC20 public rewardToken;

     // Halving period in seconds, should be defined as 2 weeks
     uint256 public halvingPeriod = 1209600;
     // Total reward in 18 decimal
     uint256 public totalreward;
     // Starting timestamp for LaunchField
     uint256 public starttime;
     uint256 public eraPeriod = 0;
     uint256 public rewardRate = 0;
     uint256 public lastUpdateTime;
     uint256 public rewardPerTokenStored;
     uint256 public totalRewards = 0;

     mapping(address => uint256) public userRewardPerTokenPaid;
     mapping(address => uint256) public rewards;

     event RewardAdded(uint256 reward);
     event Staked(address indexed user, uint256 amount);
     event Withdrawn(address indexed user, uint256 amount);
     event RewardPaid(address indexed user, uint256 reward);

     modifier updateReward(address account) {
         rewardPerTokenStored = rewardPerToken();
         lastUpdateTime = lastTimeRewardApplicable();
         if (account != address(0)) {
             rewards[account] = earned(account);
             userRewardPerTokenPaid[account] = rewardPerTokenStored;
         }
         _;
     }

     constructor(address _depositToken, address _rewardToken, uint256 _totalreward, uint256 _starttime) public {
         super.initialize(_depositToken, msg.sender);
         rewardToken = IERC20(_rewardToken);

         starttime = _starttime;
         notifyRewardAmount(_totalreward.mul(50).div(100));
     }

     function lastTimeRewardApplicable() public view returns (uint256) {
         return Math.min(block.timestamp, eraPeriod);
     }

     function rewardPerToken() public view returns (uint256) {
         if (totalSupply() == 0) {
             return rewardPerTokenStored;
         }
         return
             rewardPerTokenStored.add(
                 lastTimeRewardApplicable()
                     .sub(lastUpdateTime)
                     .mul(rewardRate)
                     .mul(1e18)
                     .div(totalSupply())
             );
     }

     function earned(address account) public view returns (uint256) {
         return
             balanceOf(account)
                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
                 .div(1e18)
                 .add(rewards[account]);
     }

     function stake(uint256 amount) public updateReward(msg.sender) checkhalve checkStart{
         require(amount > 0, "ERROR: Cannot stake 0 Token");
         super._stake(amount);
         emit Staked(msg.sender, amount);
     }

     function withdraw(uint256 amount) public updateReward(msg.sender) checkhalve checkStart{
        require(amount > 0, "ERROR: Cannot withdraw 0");
        super._withdraw(amount);
        emit Withdrawn(msg.sender, amount);
    }

    function exit() external{
        withdraw(balanceOf(msg.sender));
        _getRewardInternal();
    }

     function getReward() public updateReward(msg.sender) checkhalve checkStart{
         uint256 reward = earned(msg.sender);
         uint256 bal = balanceOf(msg.sender);
         if (reward > 0) {
             rewards[msg.sender] = 0;
             if (bal > 0) {
               super._withdrawFeeOnly(bal);
             }
             rewardToken.safeTransfer(msg.sender, reward);
             emit RewardPaid(msg.sender, reward);
             totalRewards = totalRewards.add(reward);
         }
     }

     function _getRewardInternal() internal updateReward(msg.sender) checkhalve checkStart{
         uint256 reward = earned(msg.sender);
         if (reward > 0) {
             rewards[msg.sender] = 0;
             rewardToken.safeTransfer(msg.sender, reward);
             emit RewardPaid(msg.sender, reward);
             totalRewards = totalRewards.add(reward);
         }
     }

     modifier checkhalve(){
         if (block.timestamp >= eraPeriod) {
             totalreward = totalreward.mul(50).div(100);

             rewardRate = totalreward.div(halvingPeriod);
             eraPeriod = block.timestamp.add(halvingPeriod);
             emit RewardAdded(totalreward);
         }
         _;
     }

     modifier checkStart(){
         require(block.timestamp > starttime,"ERROR: Not start");
         _;
     }

     function notifyRewardAmount(uint256 reward)
         internal
         updateReward(address(0))
     {
         if (block.timestamp >= eraPeriod) {
             rewardRate = reward.div(halvingPeriod);
         } else {
             uint256 remaining = eraPeriod.sub(block.timestamp);
             uint256 leftover = remaining.mul(rewardRate);
             rewardRate = reward.add(leftover).div(halvingPeriod);
         }
         totalreward = reward;
         lastUpdateTime = block.timestamp;
         eraPeriod = block.timestamp.add(halvingPeriod);
         emit RewardAdded(reward);
     }
 }
