export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/test.com/orderers/orderer.test.com/msp/tlscacerts/tlsca.test.com-cert.pem
export PEER0_network1_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/network1.test.com/peers/peer0.network1.test.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/artifacts/channel/config/
export PRIVATE_DATA_CONFIG=${PWD}/artifacts/private-data/collections_config.json
export CHANNEL_NAME=instancechannel

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

presetup() {
    echo "--> running presetup"
    echo "--> vendoring go dependencies..."
    pushd ./artifacts/src/github.com/deviceChaincode/go
    GO111MODULE=on go mod vendor
    popd
    echo "...done"
}

export CC_RUNTIME_LANGUAGE="golang"
export VERSION="1"
export CC_SRC_PATH="./artifacts/src/github.com/deviceChaincode/go"
export CC_NAME="deviceChaincode"

packageChaincode() {
    rm -rf ${CC_NAME}.tar.gz
    echo "packaging chaincode ${CC_NAME}.tar.gz ..."
    setGlobalsForPeer0network1
    peer lifecycle chaincode package ${CC_NAME}.tar.gz \
        --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} \
        --label ${CC_NAME}_${VERSION}
    echo "...done"
}

installChaincode() {
    setGlobalsForPeer0network1
    echo "--> installing chaincode on peer0.network1"
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "...done"
}

queryInstalledPeer0network1() {
    echo "--> querying installed chaincode on peer0.network1"
    setGlobalsForPeer0network1
    peer lifecycle chaincode queryinstalled >&log.txt
    cat log.txt
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    echo "...done"
}

approveForMynetwork1() {
    setGlobalsForPeer0network1
    echo "-->approving chaincode for network1..."
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.test.com --tls \
        --collections-config $PRIVATE_DATA_CONFIG \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --init-required --package-id ${PACKAGE_ID} \
        --sequence ${VERSION}
    echo "...done"
}

getBlock() {
    setGlobalsForPeer0network1
    peer channel getinfo  -c instancechannel -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.test.com --tls \
        --cafile $ORDERER_CA
}

checkCommitReadyness() {
    setGlobalsForPeer0network1
    echo "--> checking commit readynessn on peer0.network1 ..."
    peer lifecycle chaincode checkcommitreadiness \
        --collections-config $PRIVATE_DATA_CONFIG \
        --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --sequence ${VERSION} --output json --init-required
    echo "...done"
}

commitChaincodeDefination() {
    setGlobalsForPeer0network1
    peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.test.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --collections-config $PRIVATE_DATA_CONFIG \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_network1_CA \
        --version ${VERSION} --sequence ${VERSION} --init-required
    echo "problem is here"
}

queryCommitted() {
    setGlobalsForPeer0network1
    peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME}
}

chaincodeInvokeInit() {
    setGlobalsForPeer0network1
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.test.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_network1_CA \
        --isInit -c '{"Args":[]}'
}

chaincodeInvoke() {
    setGlobalsForPeer0network1
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.test.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_network1_CA \
        -c '{"function": "initLedger","Args":[]}'
}

chaincodeQuery() {
    setGlobalsForPeer0network1
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "retrieveDevice","Args":["12:34:56:78:AB"]}'
}

presetup
packageChaincode
installChaincode

queryInstalledPeer0network1
approveForMynetwork1
checkCommitReadyness

commitChaincodeDefination
queryCommitted
chaincodeInvokeInit
sleep 5
chaincodeInvoke
sleep 3
chaincodeQuery
