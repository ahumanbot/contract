#CONNECTING GETH TO ROPSTEN
geth --networkid 3 --rpc --rpccorsdomain "*" --rpcapi "admin,debug,miner,shh,txpool,personal,eth,net,web3" --unlock 0 --cache=1024 console

#SETTING PRIVATE NETWORK
geth --datadir "~/apps/lap" --port 30304 --nodiscover console networkid 7234789234


#DEPLOY BTC RELAY
pyepm deploy/deployRelay.yaml -a 0xfb31cb45d058b0f2e13c24eacd39230d74c4f6f5



#BITCOIN
After having installed Bitcoin core on your machine, run the following command to start synchronising the testnet blockchain

bitcoind -testnet -daemon

The synchronisation starts as a daemon and runs in the background, you can issue the following the command to see the progress

tailf ~/.bitcoin/testnet3/debug.log

To access the command line apis , just add the -testnet parameter

bitcoin-cli -testnet getinfo