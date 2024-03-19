#!/bin/bash
set -eu


# 보내는 계정의 정보
sender_address="0xYOUR_SENDER_ADDRESS" # 보내는 계정의 주소
sender_private_key="YOUR_SENDER_PRIVATE_KEY" # 보내는 계정의 개인 키

# 받는 계정의 정보
recipient_address="0xRECIPIENT_ADDRESS" # 받는 계정의 주소

# 보낼 금액
amount_to_send=1 # 보낼 이더 금액 (단위: 이더)

# if receiver have more eth than amount to send, return
balance=$(curl -s -X POST --data '{"jsonrpc":"2.0","method":"eth_getBalance","params":["'"$sender_address"'", "latest"],"id":1}' -H "Content-Type: application/json" | jq -r .result)
if [ $balance -lt $amount_to_send ]; then
  echo "$Receiver Already have enough balance"
  exit 0
fi

nonce=$(curl -s -X POST --data '{"jsonrpc":"2.0","method":"eth_getTransactionCount","params":["'"$sender_address"'", "latest"],"id":1}' -H "Content-Type: application/json" | jq -r .result)
gas_price=$(curl -s -X POST --data '{"jsonrpc":"2.0","method":"eth_gasPrice","params":[],"id":2}' -H "Content-Type: application/json" | jq -r .result)
raw_tx='{"nonce":"0x'$nonce'","gasPrice":"'$gas_price'","gas":"0x5208","to":"'"$recipient_address"'","value":"'$amount_to_send'000000000000000000"}'
signed_tx=$(echo "$raw_tx" | jq -r '.nonce="0x'+$nonce+'"' | jq -r '.gasPrice="0x'+$gas_price+'"' | jq -R . | jq -r '. | @base64' | xargs echo -n | base64 --decode | /usr/local/bin/ethsign)
tx_hash=$(echo '{"jsonrpc":"2.0","method":"eth_sendRawTransaction","params":["'"$signed_tx"'"],"id":1}' | curl -s -X POST -H "Content-Type: application/json" -d @- http://localhost:8545 | jq -r .result)
echo "Transaction Hash: $tx_hash"