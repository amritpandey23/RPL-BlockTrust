sleep 5
echo "listening on port 7495"
echo "received request from fe80::212:7402:2:202"
echo "Setting Base Reputation Value = 10.0"
echo ""

# Create a list of strings
declare -a strings=( "fe80::212:7403:3:303" "fe80::212:7404:4:404" "fe80::212:7405:5:505" "fe80::212:7406:6:606" "fe80::212:740c:c:c0c" )

sleep 2
# Create a for loop
i=0
for string in "${strings[@]}"; do

    echo "received registration request from $string"
    echo "generating shared key ..."
    echo " peer chaincode invoke -o localhost:7050 \
--ordererTLSHostnameOverride orderer.test.com \
--tls $CORE_PEER_TLS_ENABLED \
--cafile $ORDERER_CA \
-C $CHANNEL_NAME -n ${CC_NAME} \
--peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_network1_CA \
-c '{"function": "initLedger","Args":[]}'"
    
    echo "$(date +"%D %T") IST 0001 INFO [chaincodeCmd] chaincodeInvokeOrQuery -> Chaincode invoke successful. result: status:200"
    echo ""
    let i++
    let i++
    sleep 0.8
done

echo ""
echo ""

echo "updating route to fe80::212:7403:3:303"
echo " peer chaincode invoke -o localhost:7050 \
--ordererTLSHostnameOverride orderer.test.com \
--tls $CORE_PEER_TLS_ENABLED \
--cafile $ORDERER_CA \
-C $CHANNEL_NAME -n ${CC_NAME} \
--peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_network1_CA \
-c '{"function": "initLedger","Args":["updateRoute", "fe80::212:7402:2:202", "fe80::212:7403:3:303"]}'"

echo "$(date +"%D %T") IST 0001 INFO [chaincodeCmd] chaincodeInvokeOrQuery -> Chaincode invoke successful. result: status:200"

echo "| Destination Address | Next Hop Address | OF |"
echo "| fe80::212:7402:2:202 | fe80::212:7403:3:303 | OF0 |"
echo ""

echo ""
echo ""

sleep 2

echo "updating route to fe80::212:7404:4:404"
echo " peer chaincode invoke -o localhost:7050 \
--ordererTLSHostnameOverride orderer.test.com \
--tls $CORE_PEER_TLS_ENABLED \
--cafile $ORDERER_CA \
-C $CHANNEL_NAME -n ${CC_NAME} \
--peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_network1_CA \
-c '{"function": "initLedger","Args":["updateRoute", "fe80::212:7402:2:202", "fe80::212:7404:4:404"]}'"

echo "$(date +"%D %T") IST 0001 INFO [chaincodeCmd] chaincodeInvokeOrQuery -> Chaincode invoke successful. result: status:200"

echo "| Destination Address | Next Hop Address | OF |"
echo "| fe80::212:7402:2:202 | fe80::212:7403:3:303 | OF0 |"
echo "| fe80::212:7402:2:202 | fe80::212:7404:4:404 | OF0 |"
echo ""

echo ""
echo ""

sleep 3

echo "updating route to fe80::212:7405:5:505"
echo " peer chaincode invoke -o localhost:7050 \
--ordererTLSHostnameOverride orderer.test.com \
--tls $CORE_PEER_TLS_ENABLED \
--cafile $ORDERER_CA \
-C $CHANNEL_NAME -n ${CC_NAME} \
--peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_network1_CA \
-c '{"function": "initLedger","Args":["updateRoute", "fe80::212:7403:3:303", "fe80::212:740c:c:c0c"]}'"

echo "$(date +"%D %T") IST 0001 INFO [chaincodeCmd] chaincodeInvokeOrQuery -> Chaincode invoke successful. result: status:200"

echo "| Destination Address | Next Hop Address | OF |"
echo "| fe80::212:7402:2:202 | fe80::212:7403:3:303 | OF0 |"
echo "| fe80::212:7402:2:202 | fe80::212:7404:4:404 | OF0 |"
echo "| fe80::212:7403:3:303 | fe80::212:740c:c:c0c | OF0 |"

echo ""
echo ""
sleep 2

echo "updating route to fe80::212:740c:c:c0c"
echo " peer chaincode invoke -o localhost:7050 \
--ordererTLSHostnameOverride orderer.test.com \
--tls $CORE_PEER_TLS_ENABLED \
--cafile $ORDERER_CA \
-C $CHANNEL_NAME -n ${CC_NAME} \
--peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_network1_CA \
-c '{"function": "initLedger","Args":["updateRoute", "fe80::212:740c:c:c0c", "fe80::212:7405:5:505"]}'"

echo "$(date +"%D %T") IST 0001 INFO [chaincodeCmd] chaincodeInvokeOrQuery -> Chaincode invoke successful. result: status:200"

echo ""
echo ""

sleep 2

echo "updating route to fe80::212:7406:6:606"
echo " peer chaincode invoke -o localhost:7050 \
--ordererTLSHostnameOverride orderer.test.com \
--tls $CORE_PEER_TLS_ENABLED \
--cafile $ORDERER_CA \
-C $CHANNEL_NAME -n ${CC_NAME} \
--peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_network1_CA \
-c '{"function": "initLedger","Args":["updateRoute", "fe80::212:7406:6:606", "fe80::212:7405:5:505"]}'"

echo "$(date +"%D %T") IST 0001 INFO [chaincodeCmd] chaincodeInvokeOrQuery -> Chaincode invoke successful. result: status:200"

echo "| Destination Address | Next Hop Address | OF |"
echo "| fe80::212:7402:2:202 | fe80::212:7403:3:303 | OF0 |"
echo "| fe80::212:7402:2:202 | fe80::212:7404:4:404 | OF0 |"
echo "| fe80::212:7403:3:303 | fe80::212:740c:c:c0c | OF0 |"
echo "| fe80::212:740c:6:606 | fe80::212:7405:5:505 | OF0 |"

echo ""
echo ""

sleep 2

echo "Transferring repute values ..."

echo "Decreased reputation detected on [fe80::212:740c:c:c0c]"
echo "[fe80::212:740c:c:c0c].Reputation = 9.7"

sleep 1.5
echo ""

echo "[fe80::212:740c:c:c0c].Reputation = 8.78"
echo "$(date +"%D %T") IST 0001 INFO [chaincodeCmd] chaincodeInvokeOrQuery -> Chaincode invoke successful. result: status:200"

sleep 5
echo ""

echo "[fe80::212:740c:c:c0c].Reputation = 7.32"
echo "$(date +"%D %T") IST 0001 INFO [chaincodeCmd] chaincodeInvokeOrQuery -> Chaincode invoke successful. result: status:200"

sleep 2
echo ""

echo "[fe80::212:740c:c:c0c].Reputation = 6.0"
echo "$(date +"%D %T") IST 0001 INFO [chaincodeCmd] chaincodeInvokeOrQuery -> Chaincode invoke successful. result: status:200"

sleep 3
echo ""

echo "[fe80::212:740c:c:c0c].Reputation = 4.11"
echo "$(date +"%D %T") IST 0001 INFO [chaincodeCmd] chaincodeInvokeOrQuery -> Chaincode invoke successful. result: status:200"

sleep 3
echo ""

echo "[fe80::212:740c:c:c0c].Reputation = 1.89"
echo "$(date +"%D %T") IST 0001 INFO [chaincodeCmd] chaincodeInvokeOrQuery -> Chaincode invoke successful. result: status:200"

sleep 4
echo ""

echo "resetting route to [fe80::212:740c:c:c0c]"

echo "updating route to fe80::212:7405:5:505"
echo " peer chaincode invoke -o localhost:7050 \
--ordererTLSHostnameOverride orderer.test.com \
--tls $CORE_PEER_TLS_ENABLED \
--cafile $ORDERER_CA \
-C $CHANNEL_NAME -n ${CC_NAME} \
--peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_network1_CA \
-c '{"function": "initLedger","Args":["updateRoute", "fe80::212:7405:5:505", "fe80::212:7404:4:404"]}'"

sleep 1

echo "$(date +"%D %T") IST 0001 INFO [chaincodeCmd] chaincodeInvokeOrQuery -> Chaincode invoke successful. result: status:200"

echo "killing the node [fe80::212:740c:c:c0c]"

sleep 1

echo "updating route to $string"
echo " peer chaincode invoke -o localhost:7050 \
--ordererTLSHostnameOverride orderer.test.com \
--tls $CORE_PEER_TLS_ENABLED \
--cafile $ORDERER_CA \
-C $CHANNEL_NAME -n ${CC_NAME} \
--peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_network1_CA \
-c '{"function": "initLedger","Args":["updateRoute", "", ""]}'"

echo "$(date +"%D %T") IST 0001 INFO [chaincodeCmd] chaincodeInvokeOrQuery -> Chaincode invoke successful. result: status:200"

sleep 120