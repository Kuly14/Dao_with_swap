// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Dao is Ownable {

	uint public timePeriod = 10 minutes;
	uint public votingPeriod;
	uint public totalVotes;
	uint public totalPower;
	address public winner;
	bool internal alreadyUsed;


	struct Proposal {
		address recipient;
		uint amountForProject;
		string name;
		string proposalText;
		uint TotalVotesForProposal;
		// Passed will be required if you the contract will send the tokens.
		bool passed;
		uint assignedPower;
	}

	struct Voter {
		address voterAddress;
		uint vote;
		uint power;
		bool authorized;
		bool voted;
		bool usedGetPowerFunction;
	}

	enum ELECTION_STATE {
		OPEN,
		CLOSED
	}

	ELECTION_STATE public election_state;
	Proposal[] public proposals;
	mapping(address => Voter) public voters;
	IERC20 public daoToken;

	constructor(address _dappTokenAddress) {
		election_state = ELECTION_STATE.CLOSED;
		daoToken = IERC20(_dappTokenAddress);	
	}

	function buyTokens(address _recipient) payable public {
		require(daoToken.balanceOf(address(this)) > 500000000000000000000000, "All the tokens were sold");
		require(msg.value > 0, "You need to send some money to receive tokens");
		require (msg.value < 1000000000000000000000, "Most you can purchase is 10 000 tokens");
		uint valueToSend = msg.value * 10;
		daoToken.transfer(_recipient, valueToSend);
	}

	function showHowManyTokensIOwn() public view returns(uint) {
		uint balance = daoToken.balanceOf(msg.sender);
		return balance;
	}


	function startVoting() public onlyOwner {
		require(alreadyUsed == false, "This contract is one use only!");
		require(election_state == ELECTION_STATE.CLOSED);
		votingPeriod = block.timestamp + timePeriod;
		election_state = ELECTION_STATE.OPEN;
	}

	function registerProposal(address _recipient, uint _amount, string memory _name, string memory _proposal) public {
		require(_amount <= 100000000000000000000000, "The maximum amount you can ask for is 100 000 tokens");
		require(election_state == ELECTION_STATE.OPEN, "Voting isn't opened yet");
		proposals.push(Proposal(_recipient, _amount, _name, _proposal, 0, false, 0));
	}

	function getPower() payable public {
		require(voters[msg.sender].usedGetPowerFunction == false, "You can use this function only once");
		require(daoToken.balanceOf(msg.sender) > 0);
		require(election_state == ELECTION_STATE.OPEN, "Voting isn't open yet");
		require(msg.value > 0, "You need to send a little bit of eth so we can confirm ownership of your address, we will send it back to you immidiately. You can send just a few wei it doesn't matter.");
		voters[msg.sender].power = daoToken.balanceOf(msg.sender);
		totalPower += voters[msg.sender].power;
		voters[msg.sender].usedGetPowerFunction = true;
	}


	function showPower() public view returns (uint) {
		uint power = voters[msg.sender].power;
		return power;
	}

	function vote(uint _vote) public {
		require(voters[msg.sender].voted == false, "You already voted");
		require(voters[msg.sender].power > 0, "You need to have some power to vote");
		require(election_state == ELECTION_STATE.OPEN, "Voting isn't open yet");
		voters[msg.sender].vote = _vote;
		uint amountOfPower = voters[msg.sender].power;
		proposals[_vote].TotalVotesForProposal += 1; 
		proposals[_vote].assignedPower += amountOfPower;
		voters[msg.sender].voted = true;
		totalVotes++;
	} 

	function endVoting() public onlyOwner {
		// require(block.timestamp > votingPeriod, "The voting hasn't ended yet!")
		require(election_state == ELECTION_STATE.OPEN);
		election_state = ELECTION_STATE.CLOSED;
	}

	function countVotes() public view onlyOwner returns (uint _winningProposal) {
		uint mostPower = 0;
		for (uint index = 0; index < proposals.length; index++) {
			if (proposals[index].assignedPower > mostPower) {
				mostPower = proposals[index].assignedPower;
				_winningProposal = index;
			}
		}
	}


	function winnerName() public view returns(string memory) {
		// require(block.timestamp > votingPeriod, "The voting hasn't ended yet!")
		require(election_state == ELECTION_STATE.CLOSED, "Election hasn't ended yet");
		string memory winningName = proposals[countVotes()].name;
		return winningName;
	}

	function sendResources() public onlyOwner {
		require(election_state == ELECTION_STATE.CLOSED);
		// require(block.timestamp > votingPeriod);
		uint amountToSend = proposals[countVotes()].amountForProject;
		winner = proposals[countVotes()].recipient;
		daoToken.transfer(winner, amountToSend);
	}


	function showAllProposalsAndVotes() public view returns (string memory) {
		for (uint index; index < proposals.length; index++) {
			string memory _string;
			_string = proposals[index].name;
			return(_string);
		}
	}


	function withdraw() public onlyOwner {
		// This function is just for testing so your testnet eth doesn't get stuck in the contract.
		uint amountToWithdraw = address(this).balance;
		payable(msg.sender).transfer(amountToWithdraw);
	}
}