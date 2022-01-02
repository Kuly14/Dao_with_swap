from scripts.help import get_account
from brownie import interface, config, network, accounts, MockWETH
import sys


def main():
    # get_weth()
    get_weth_mock()


def get_weth():
    """
    Mints WETH by depositing ETH.
    """
    account = get_account()
    weth = interface.IWeth(config["networks"][network.show_active()]["weth_token"])
    tx = weth.deposit({"from": account, "value": 0.1 * 10 ** 18})
    tx.wait(1)
    print("Received 1 WETH")

def get_weth_mock():
    account = get_account()
    weth_token = MockWETH.deploy({"from": account})
    weth = interface.IWeth(weth_token)
    tx = weth.deposit({"from": account, "value": 0.1 * 10 ** 18})
    tx.wait(1)
    print("Received 1 WETH")
