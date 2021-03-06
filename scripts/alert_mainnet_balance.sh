##!/bin/bash
url='https://bitcoin.toshi.io/api/v0/addresses/'
address='1PMii38r8i1Nk2GjtPX1JcJrXR81Xw6tCZ'
threshold=50000000
network="mainnet"

url=$url$address

address_data=$(curl $url)

balance=$(echo $address_data | grep -o  '\"balance\"\:[0-9]*' | cut -d ":" -f 2)

if test "$balance" = "" ;then	
	echo "Address ["$address"] seems like an unused address"
    exit 1
else
  if test "$balance" -gt "$threshold" ;then	
      echo "success"
  else
      echo "failure, "$network" balance fell below ["$threshold"] Satoshis. There are only ["$balance"] Satoshis left."
      exit 1
  fi	
fi