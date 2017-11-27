#CONNECTING GETH TO ROPSTEN
geth --networkid 3 --rpc --rpccorsdomain "*" --rpcapi "admin,debug,miner,shh,txpool,personal,eth,net,web3" --unlock 0 --cache=1024 --datadir="/media/qq/SSD/geth/testnet" console



mist --rpc /media/qq/SSD/geth/testnet/geth.ipc --swarmurl="http://swarm-gateways.net" --network test 

#SETTING PRIVATE NETWORK
geth --datadir "~/apps/lap" --port 30304 --nodiscover console networkid 7234789234


#DEPLOY BTC RELAY
pyepm deploy/deployRelay.yaml -a 0xfb31cb45d058b0f2e13c24eacd39230d74c4f6f5



#BITCOIN
https://github.com/bitpay/insight
https://stackoverflow.com/questions/31025159/installing-nodejs-without-sudo-in-ubuntu
killall -9 bitcoind

https://bitcore.io/guides/full-node/


