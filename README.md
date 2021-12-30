# DAO VOTING

## Overview

This is a voting contract for DAO. Firstly anybody can buy the Dao tokens using the buyTokens() function. The price of the tokens is constant. For each eth you get 10 Dao tokens. In the future I will add a function that will move the price based on liquidity using the AMM algorithm

Then call the startVoting() function. Without calling this function any other functions won't work. The voting part of the function is one use only until I figure out how to reset all the arrays and mappings which will be in later verisions. This will also start a timer in this case only for 10 minutes in which the voting takes place. You can modify this by changing the timePeriod uint to whatever timePeriod you want.

Members of the community can register proposals whith the amount they want to receive if they win. 
Then if you want to vote you need to call the getPower() function and with that send a little bit of Eth so the contract can verify that you are the owner of the address. 

You can send just a few wei it doesn'y really matter. Once the address is verified it looks at how much Dao tokens you own and assign power based on that. You can use this function only once. After the function finishes the contract will send the eth back to you.

Now you can vote. Call the function with number of the proposal you want to vote for. The logic goes like this 0 = 1st proposal 1 = 2nd proposal and so on.

After the timePeriod ends call the endVoting(). This function won't work until the timePeriod expires.

Now call the countVotes() function which will count all the votes.

To see the winner call winnerName() this will return the name of the winning proposal. 

Now that the winner was chosen call the sendResources() function which will send the asked amount of the tokens to the owner of the proposal. So he can go and do what he proposed in the proposal. He will recieve DAO tokens.

And that's it the voting is over.







## Requirements to run

Brownie
Ganache CLI

If you want to run it on realy testnet add .env file in which should be PRIVATE_KEY of your test wallet and WEB3_INFURA_PROJECT_ID 
which you can get at https://infura.io/







## How to run

To run this contract open your terminal and write git clone (url of this repo) this will copy the repo to your computer.

Now write brownie run scripts/deploy.py

If you want to run on real testnet write brownie run scripts/deploy.py --network kovan (or testnet of your choice) 

This will run the contract.





## Files

### Dao.sol
Is the voting contract.

### Token.sol
Creates the Dao token

### deploy.py
Is the script used to run the contract

### help.py
Is a helpful script tha deploy.py calls