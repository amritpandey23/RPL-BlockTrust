export SYS_CHANNEL="sys-channel"
export CHANNEL_NAME="instancechannel"

if test -d "./crypto-config"; then
    echo "--> deleting existing artifacts ..."
    chmod -R 0755 ./crypto-config;
    rm -rf ./crypto-config;
    if test -f "genesis.block"; then
        echo "--> removing genesis.block"
        rm genesis.block;
    fi
    if test -f "instanceChannel.tx"; then
        echo "--> removing instanceChannel.tx"
        rm instanceChannel.tx;
    fi
    if test -f "network1MSPanchors.tx"; then
        echo "--> removing network1MSPanchors.tx"
        rm network1MSPanchors.tx;
    fi
    echo "...done"
    echo ""
fi

echo "--> generating new crypto artifacts for: "
cryptogen generate --config=./crypto-config.yaml --output=./crypto-config/
echo "...done"
echo ""

echo "--> generating genesis block..."
configtxgen -profile OrdererGenesis -configPath . -channelID $SYS_CHANNEL  -outputBlock ./genesis.block
echo "...done"
echo ""

echo "--> generating configuration block..."
configtxgen -profile BasicChannel -configPath . -outputCreateChannelTx ./${CHANNEL_NAME}.tx -channelID $CHANNEL_NAME
echo "...done"
echo ""

echo "--> generating anchor peer update for network1MSP..."
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./network1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg network1MSP
echo "...done"
echo ""
