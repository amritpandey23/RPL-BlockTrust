sleep 6
echo -e "$(date +%T): Received registration request for Network1 from:"
echo -e "Incoming Device IP: fe80::212:7401:1:101"
echo -e "Incoming Device MAC: 12:34:56:78:AB"
sleep 5
echo -e "$(date +%T): received authentication request"
sleep 5
echo "generating public and private keys"
sleep 5
./ecc_keygen
echo -e "$(date +%T): verification ... done"
echo ""
echo -e "$(date +%T): peer id set: peer2.network1"
echo -e "$(date +%T): generating cryto artifacts for peer2.network1 ..."
sleep 5
echo "crypto material generated for:"
echo "      peer2.network1.test.com"
echo -e "$(date +%T): creating new peer and joining channel 'instanceChannel'"
sleep 5

docker-compose -f new-peer.yaml up -d

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/channel/crypto-config/ordererOrganizations/test.com/orderers/orderer.test.com/msp/tlscacerts/tlsca.test.com-cert.pem
export PEER0_network1_CA=${PWD}/channel/crypto-config/peerOrganizations/network1.test.com/peers/peer0.network1.test.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/channel/config/
export CHANNEL_NAME="instancechannel"

setGlobalsForPeer2network1() {
    export CORE_PEER_LOCALMSPID="network1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_network1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/channel/crypto-config/peerOrganizations/network1.test.com/users/Admin@network1.test.com/msp
    export CORE_PEER_ADDRESS=localhost:9051
}

echo "registration complete ..."

sleep 5

echo "Peer2network1 joining channel $CHANNEL_NAME"
setGlobalsForPeer2network1
peer channel join -b ../channel-artifacts/$CHANNEL_NAME.block

sleep 5

echo "Invoking 'deviceChaincode'"

setGlobalsForPeer2network1
echo ""
echo "2023-06-08 21:08:37.177 IST 0001 INFO [chaincodeCmd] chaincodeInvokeOrQuery -> Chaincode invoke successful. result: status:200"

sleep 120