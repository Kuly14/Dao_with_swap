from brownie import Dao, Token, network, config
from scripts.help import get_account
from web3 import Web3


KEPT_BALANCE = Web3.toWei(10, "ether")

def deploy():
	account = get_account()
	token = Token.deploy({"from": account})
	dao = Dao.deploy(token.address, {"from": account})
	# tx = token.transfer(dao.address, token.totalSupply() - KEPT_BALANCE, {"from": account})
	tx = token.transfer(dao.address, token.totalSupply(), {"from": account})
	tx.wait(1)
	print("Dao deployed succesfuly!")

def buy_tokens():
	account = get_account()
	dao = Dao[-1]
	amount = Web3.toWei(0.1, "ether")
	tx = dao.buyTokens(account, {"from": account, "value": amount})
	tx.wait(1)
	print("Tokens bought succesfuly!")

def showAllTokesIOwn():
	account = get_account()
	dao = Dao[-1]
	tx = dao.showHowManyTokensIOwn({"from": account})
	print(f"You have {tx} tokens in wei")


def start_voting():
	account = get_account()
	dao = Dao[-1]
	tx = dao.startVoting({"from": account})
	tx.wait(1)
	print("Voting started")


def register_proposal():
	account = get_account()
	dao = Dao[-1]
	amount = Web3.toWei(10000, "ether")
	tx = dao.registerProposal(account, amount, "Proposal1", "Create Flash Loan platform", {"from": account})
	tx.wait(1)
	tx2 = dao.registerProposal(account, amount, "Proposal2", "Create Flash Loan platform2", {"from": account})
	tx2.wait(1)
	print("Proposals registered succesfuly!")


def getPower():
	account = get_account()
	dao = Dao[-1]
	amount = Web3.toWei(0.001, "ether")
	tx = dao.getPower({"from": account, "value": amount})
	tx.wait(1)
	print("Power swithched!")


def showPower():
	account = get_account()
	dao = Dao[-1]
	tx = dao.showPower({"from": account})
	print(f"Your power is {tx}")

def vote():
	account = get_account()
	dao = Dao[-1]
	tx = dao.vote(0, {"from": account})
	tx.wait(1)
	print("You voted succesfuly!")


def end_voting():
	account = get_account()
	dao = Dao[-1]
	tx = dao.endVoting({"from": account})
	print("Voting ended succesfuly!")


def count_votes():
	account = get_account()
	dao = Dao[-1]
	tx = dao.countVotes({"from": account})
	print("Votes counted succesfuly!")


def winner():
	account = get_account()
	dao = Dao[-1]
	tx = dao.winnerName({"from": account})
	print(f"Winner is {tx}")

def sendResourcesToWinner():
	account = get_account()
	dao = Dao[-1]
	tx = dao.sendResources({"from": account})
	tx.wait(1)
	print("Resources sent succesfuly!")


def withdraw():
	# This function is just for testing so your testnet eth doesn't get stuck in the contract.
	account = get_account()
	dao = Dao[-1]
	tx = dao.withdraw({"from": account})
	tx.wait(1)
	print("All eth withdrawn succesfuly!")



def main():
	deploy()
	buy_tokens()
	showAllTokesIOwn()
	start_voting()
	register_proposal()
	getPower()
	showPower()
	vote()
	end_voting()
	winner()
	sendResourcesToWinner()
	withdraw()