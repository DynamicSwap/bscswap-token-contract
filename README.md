# bscswap-token-contract
Risk-reduced Yield Farming implementation in Solidity

### BEP20 Token Contract

The code of BSCswap (BSWAP) BEP20 governance token implementation lives here.

https://github.com/hyunsikswap/bscswap-token-contract/blob/master/contracts/BSWAP.sol

https://github.com/hyunsikswap/bscswap-token-contract/blob/master/flatten/BSWAP.sol ( full code with imported libraries from audited @openzeppelin contracts )

https://bscscan.com/address/0xacc234978a5eb941665fd051ca48765610d82584#code (Deployed on Mainnet)

There is no powerful function for the contract deployer as well as assigning `minter`, or assigning accounts for `blacklist` , etc.

The token cap is limited to the first minted supply https://github.com/hyunsikswap/bscswap-token-contract/blob/master/contracts/BSWAP.sol#L13 that is sended to the deployer of the contract.

Also, new `ERC20Burnable.sol` library from openzeppelin is being used to burn tokens with the total supply count decreased. https://github.com/hyunsikswap/bscswap-token-contract/blob/master/contracts/BSWAP.sol#L7

So better use the burn function rather than sending tokens to the famous [burn address](https://bscscan.com/address/0x000000000000000000000000000000000000dEaD).

### LaunchField Mining Contract

The code of LaunchField (Yield Farming) contract lives here.

https://github.com/hyunsikswap/bscswap-token-contract/blob/master/contracts/LaunchField.sol

https://github.com/hyunsikswap/bscswap-token-contract/blob/master/contracts/StakePool.sol

https://github.com/hyunsikswap/bscswap-token-contract/blob/master/flatten/LaunchField.sol ( full code with imported libraries from audited @openzeppelin contracts )

The contract is originally forked from https://github.com/cryptoghoulz/based-contracts/blob/master/contracts/v5/Pool1.sol and https://github.com/milk-protocol/stakecow-contracts-bsc/blob/master/contracts/FomoCow.sol

### BSCswap Main contracts

Like Uniswap, we have 2 contracts deployed on BSC mainnet for [BSCswap.com] Decentralized Exchange.

Uniswap Router02 (Used for front interface interacting with pairs and factory contract)

https://etherscan.io/address/0x7a250d5630b4cf539739df2c5dacb4c659f2488d#code

Uniswap Factory (Used for creating pairs)

https://etherscan.io/address/0x5c69bee701ef814a2b6a3edd4b1652cb9cc5aa6f#code

BSCswap Router

https://bscscan.com/address/0xd954551853F55deb4Ae31407c423e67B1621424A#code

https://github.com/bscswap/contracts/blob/master/flatten/BSCswapRouter.sol

BSCswap Factory

https://bscscan.com/address/0xce8fd65646f2a2a897755a1188c04ace94d2b8d0#code

https://github.com/bscswap/contracts/blob/master/flatten/BSCswapFactory.sol

The contracts of BSCswap have been modified to make the codes compatible with newest solidity version.
