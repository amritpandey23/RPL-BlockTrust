export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/test.com/orderers/orderer.test.com/msp/tlscacerts/tlsca.test.com-cert.pem
export PEER0_lbr1_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/lbr1.test.com/peers/peer0.lbr1.test.com/tls/ca.crt
export PEER0_lbr2_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/lbr2.test.com/peers/peer0.lbr2.test.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/artifacts/channel/config/
export PRIVATE_DATA_CONFIG=${PWD}/artifacts/private-data/collections_config.json
export CHANNEL_NAME=instancechannel

CHANNEL_NAME="instancechannel"
CC_RUNTIME_LANGUAGE="golang"
VERSION="1"
CC_SRC_PATH="./artifacts/src/github.com/deviceChaincode/go"
CC_NAME="deviceChaincode"

setGlobalsForPeer0lbr1() {
    export CORE_PEER_LOCALMSPID="lbr1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_lbr1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/lbr1.test.com/users/Admin@lbr1.test.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
}

setGlobalsForPeer0lbr1

sleep 15

peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.test.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_lbr1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_lbr2_CA \
        -c '{"function": "registerDevice", "Args":["fe80::212:7403:3:303", "10.00", "0x51897b64e85c3f714bba707e867914295a1377a7463a9dae8ea6a8b91424631"]}'

sleep 3

peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.test.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_lbr1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_lbr2_CA \
        -c '{"function": "registerDevice", "Args":"fe80::212:7404:4:404", "10.00", "0x51897b64e85c3f714bba707e867914295a1377a7463a9dae8ea6a8b91424631"]}'

sleep 3

peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.test.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_lbr1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_lbr2_CA \
        -c '{"function": "registerDevice", "Args":["fe80::212:7405:5:505", "10.00", "0x51897b64e85c3f714bba707e867914295a1377a7463a9dae8ea6a8b91424631"]}'

sleep 3

peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.test.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_lbr1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_lbr2_CA \
        -c '{"function": "registerDevice", "Args":["fe80::212:7406:6:606", "10.00", "0x51897b64e85c3f714bba707e867914295a1377a7463a9dae8ea6a8b91424631"]}'

sleep 3

peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.test.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_lbr1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_lbr2_CA \
        -c '{"function": "registerDevice", "Args":["fe80::212:7407:7:707", "10.00", "0x51897b64e85c3f714bba707e867914295a1377a7463a9dae8ea6a8b91424631"]}'

sleep 3

peer chaincode invoke -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.test.com \
    --tls $CORE_PEER_TLS_ENABLED \
    --cafile $ORDERER_CA \
    -C $CHANNEL_NAME -n ${CC_NAME} \
    --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_lbr1_CA \
    --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_lbr2_CA \
    -c '{"function": "registerDevice", "Args":["fe80::212:7408:8:808", "10.00", "0x51897b64e85c3f714bba707e867914295a1377a7463a9dae8ea6a8b91424631"]}'