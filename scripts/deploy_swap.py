from brownie import Swap, Token, MockWETH, config, network, interface
from scripts.help import get_account
from web3 import Web3


amount = Web3.toWei(0.1, "ether")

def deploy_token_and_swap():
	account = get_account()
	erc20_address = config["networks"][network.show_active()]["weth_token"]
	token = Token.deploy({"from": account})
	swap = Swap.deploy(token.address, config["networks"][network.show_active()]["weth_token"], {"from": account})
	tx = token.transfer(swap.address, token.totalSupply(), {"from": account})
	tx.wait(1)
	approve_tx = approve_erc20(amount, swap.address, erc20_address, account)
	print("Swap deployed and token transfered!")





def approve_erc20(amount, spender, erc20_address, account):
    print("Approving ERC20 token...")
    erc20 = interface.IERC20(erc20_address)
    tx = erc20.approve(spender, amount, {"from": account})
    tx.wait(1)
    print("Approved!")
    return tx



def set_const():
	account = get_account()
	swap = Swap[-1]
	amount = Web3.toWei(0.1, "ether")
	tx = swap.setConstant(amount, {"from": account})
	tx.wait(1)
	print("Constant set!")


def add_allowed_tokens():
	account = get_account()
	swap = Swap[-1]
	token = Token[-1]
	tx = swap.addAllowedTokes(config["netowrks"][network.show_active()]["weth_token"], {"from": account})
	tx.wait(1)
	tx2 = swap.addAllowedTokes(token.address, {"from": account})
	tx2.wait(1)
	print("Tokens allowed!")

def swap_tokens():
	account = get_account()
	swap = Swap[-1]
	token = Token[-1]
	erc20_address = token.address
	amount = Web3.toWei(100, "ether")
	approve_tx = approve_erc20(amount, swap.address, erc20_address, {"from": account})





def main():
	deploy_token_and_swap()
	set_const()
	add_allowed_tokens()
