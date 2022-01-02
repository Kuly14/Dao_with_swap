from brownie import Swap, Token, config, network, LocalToken, interface
from scripts.help import get_account
from web3 import Web3


amount = Web3.toWei(1, "ether")


def deploy_token_and_swap():
	account = get_account()
	
	token = Token.deploy({"from": account})
	# weth_token = MockWETH.deploy({"from": account})
	local_token = LocalToken.deploy({"from": account})
	tx = local_token.transfer(account, local_token.totalSupply(), {"from": account})
	print("Mock deployed!")
	swap = Swap.deploy(token.address, local_token.address, {"from": account})
	tx = token.transfer(swap.address, token.totalSupply(), {"from": account})
	tx.wait(1)
	approve_tx = approve_erc20(amount, swap.address, local_token.address, account)
	print("Swap deployed and token transfered!")





def approve_erc20(amount, spender, erc20_address, account):
    print("Approving ERC20 token...")
    erc20 = interface.IERC20(erc20_address)
    tx = erc20.approve(spender, amount, {"from": account})
    tx.wait(1)
    print("Approved!")
    return tx

# def approveSpender():
# 	account = get_account()
# 	swap = Swap[-1]
# 	amount = 1000000000000000000000
# 	tx = swap.approveAccount(account, amount, {"from": account})
# 	tx.wait(1)




def set_const():
	account = get_account()
	swap = Swap[-1]
	amount = Web3.toWei(1, "ether")
	tx = swap.setConstant(amount, {"from": account})
	tx.wait(1)
	print("Constant set!")
	tx3 = swap.constantOfTheSwap()
	print(tx3)


def add_allowed_tokens():
	account = get_account()
	swap = Swap[-1]
	token = Token[-1]
	local_token = LocalToken[-1]
	tx = swap.addAllowedTokes(local_token.address, {"from": account})
	tx.wait(1)
	tx2 = swap.addAllowedTokes(token.address, {"from": account})
	tx2.wait(1)
	print("Tokens allowed!")


def swap_tokens():
	account = get_account()
	swap = Swap[-1]
	token = Token[-1]
	local_token = LocalToken[-1]
	erc20_address = token.address
	amount = Web3.toWei(100, "ether")
	approve_tx = approve_erc20(amount, swap.address, local_token.address, account)
	tx_swap = swap.swap(local_token.address, amount, {"from": account})
	tx_swap.wait(1)
	print("tokens swapped")



def main():
	deploy_token_and_swap()
	# approveSpender()
	set_const()
	add_allowed_tokens()
	swap_tokens()


