pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// @TODO: Inherit the crowdsale contracts
contract PupperCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale {

    constructor(
        // @TODO: Fill in the constructor parameters!
        uint rate,
        address payable wallet,
        PupperCoin token, 
        uint goal,
        uint open,
        uint close
        
    )
        // @TODO: Pass the constructor parameters to the crowdsale contracts.
        Crowdsale (
            rate,
            wallet,
            token
            )
        CappedCrowdsale(
            goal
            )
        TimedCrowdsale(
            open,
            close
            )
        RefundableCrowdsale(
            goal
            )
        public
    {
        // constructor can stay empty
    }
}

contract PupperCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;

    constructor(
        // @TODO: Fill in the constructor parameters!
        string memory name,
        string memory symbol,
        address payable wallet,
        uint goal
    )
        public
    {
        // @TODO: create the PupperCoin and keep its address handy
        PupperCoin token = new PupperCoin( name,
        symbol,
        18);
        token_address = address(token);

        // @TODO: create the PupperCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
        PupperCoinSale sale_token = new PupperCoinSale(
            1,
            wallet,
            token,
            goal,
            now,
            now + 24 weeks
            );
        token_sale_address = address(sale_token);

        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}

contract MyToken is ERC20, ERC20Mintable {
    // ... see "Tokens" for more info
}

contract MyCrowdsale is Crowdsale, MintedCrowdsale {
    constructor(
        uint256 rate,    // rate in TKNbits
        address payable wallet,
        IERC20 token
    )
        MintedCrowdsale()
        Crowdsale(rate, wallet, token)
        public
    {

    }
}

contract MyCrowdsaleDeployer {
    constructor()
        public
    {
        // create a mintable token
        ERC20Mintable token = new MyToken();

        // create the crowdsale and tell it about the token
        Crowdsale crowdsale = new MyCrowdsale(
            1,               // rate, still in TKNbits
            msg.sender,      // send Ether to the deployer
            token            // the token
        );
        // transfer the minter role from this contract (the default)
        // to the crowdsale, so it can mint tokens
        token.addMinter(address(crowdsale));
        token.renounceMinter();
    }
}
