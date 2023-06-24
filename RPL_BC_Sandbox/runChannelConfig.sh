export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/test.com/orderers/orderer.test.com/msp/tlscacerts/tlsca.test.com-cert.pem
export PEER0_network1_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/network1.test.com/peers/peer0.network1.test.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/artifacts/channel/config/
export CHANNEL_NAME="instancechannel"

setGlobalsForOrderer() {
    export CORE_PEER_LOCALMSPID="OrdererMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/test.com/orderers/orderer.test.com/msp/tlscacerts/tlsca.test.com-cert.pem
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/test.com/users/Admin@test.com/msp
}

setGlobalsForPeer0network1() {
    export CORE_PEER_LOCALMSPID="network1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_network1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/network1.test.com/users/Admin@network1.test.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
}

setGlobalsForPeer1network1() {
    export CORE_PEER_LOCALMSPID="network1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_network1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/network1.test.com/users/Admin@network1.test.com/msp
    export CORE_PEER_ADDRESS=localhost:8051
}

setGlobalsForPeer2network1() {
    export CORE_PEER_LOCALMSPID="network1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_network1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/network1.test.com/users/Admin@network1.test.com/msp
    export CORE_PEER_ADDRESS=localhost:9051
}

createChannel() {
    echo "--> creating channel $CHANNEL_NAME"
    rm -rf ./channel-artifacts/*
    setGlobalsForPeer0network1
    peer channel create -o localhost:7050 -c $CHANNEL_NAME \
    --ordererTLSHostnameOverride orderer.test.com \
    -f ./artifacts/channel/${CHANNEL_NAME}.tx --outputBlock ./channel-artifacts/${CHANNEL_NAME}.block \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    echo "...done"
}

removeOldCrypto() {
    rm -rf ./api-1.4/crypto/*
    rm -rf ./api-1.4/fabric-client-kv-network1/*
    rm -rf ./api-2.0/network1-wallet/*
    rm -rf ./api-2.0/lbr2-wallet/*
}

joinChannel() {
    echo "--> Peer0network1 joining channel $CHANNEL_NAME"
    setGlobalsForPeer0network1
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    
    echo "--> Peer1network1 joining channel $CHANNEL_NAME"
    setGlobalsForPeer1network1
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
}

updateAnchorPeers(){
    setGlobalsForPeer0network1
    echo "--> updating anchor peer for network1"
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.test.com -c $CHANNEL_NAME -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
}

# removeOldCrypto
createChannel
joinChannel
updateAnchorPeers
