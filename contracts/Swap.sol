// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";



contract Swap is Ownable {

	IERC20 public daoToken;
	IERC20 public wethToken;
	address public daoTokenAddress;
	address public wethTokenAddress;
	uint public constantOfTheSwap = 0;
	

	// This will track the balance of both tokens in this contract.
	mapping(address => uint256) public balance;


	address[] public allowedTokens;


	constructor(address _daoTokenAddress, address _wethAddress) {
		// IERC20(_wethAddress).transferFrom(msg.sender, address(this), _amount);
		daoToken = IERC20(_daoTokenAddress);
		wethToken = IERC20(_wethAddress);
		daoTokenAddress = _daoTokenAddress;
		wethTokenAddress = _wethAddress;
		// constantOfTheSwap = daoToken.balanceOf(address(this)) * wethToken.balanceOf(address(this));
	}


	// function setConstant(uint _amount) public onlyOwner {
	// 	IERC20(wethTokenAddress).transferFrom(msg.sender, address(this), _amount);
	// 	constantOfTheSwap = daoToken.balanceOf(address(this)) * wethToken.balanceOf(address(this));
	// }

	// function approveAccount(address _spender, uint _amount) public {
	// 	wethToken.approve(_spender, _amount);
	// }


	function setConstant(uint _amount) public {
		require(
            wethToken.allowance(msg.sender, address(this)) >= _amount,
            "Token 1 allowance too low"
        );
        uint256 allowance = wethToken.allowance(msg.sender, address(this));		
        wethToken.transferFrom(msg.sender, address(this), _amount);
		constantOfTheSwap = daoToken.balanceOf(address(this)) * wethToken.balanceOf(address(this));
	}

	// This function will add allowed tokens. In this case dao token and weth. Weth address will get pulled from config
	// And dao token address will be called using token.address function

	// function showConstant() public view returns (uint) {
	// 	return constantOfTheSwap
	// }

	function addAllowedTokes(address _token) public onlyOwner {
		allowedTokens.push(_token);
	}


	function swap(address _token, uint _amount) public {
		require(tokenIsAllowed(_token), "This swap is only for eth and dao token");
		balance[daoTokenAddress] = daoToken.balanceOf(address(this));
		balance[wethTokenAddress] = wethToken.balanceOf(address(this));
		IERC20(_token).transferFrom(msg.sender, address(this), _amount);
		balance[_token] = balance[_token] + _amount;
		// uint amountReceived = balance[_token];
		// This part of the function will calculate how much we need to send them back
		uint constDivByBalanceOfToken = constantOfTheSwap / balance[_token];
		uint amountToSendToUser = balance[_token] - constDivByBalanceOfToken; 
		if (_token == wethTokenAddress) {
			daoToken.transfer(msg.sender, amountToSendToUser);
		}
		else if (_token == daoTokenAddress) {
			wethToken.transfer(msg.sender, amountToSendToUser);
		}
	}


	function showBalanceOfTokens() public view returns (uint, uint) {
		uint balanceOfWeth = balance[wethTokenAddress];
		uint balanceOfDao = balance[daoTokenAddress];
		return (balanceOfWeth, balanceOfDao);
	}

	function showConstant() public view returns (uint) {
		return constantOfTheSwap;
	}


	// This function checks if the allowed token is in the allowedTokens array.

    function tokenIsAllowed(address _token) public view returns (bool) {
        for( uint256 allowedTokensIndex=0; allowedTokensIndex < allowedTokens.length; allowedTokensIndex++){
            if(allowedTokens[allowedTokensIndex] == _token){
                return true;
            }
        }
        return false; 
    }



}