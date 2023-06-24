cd artifacts/channel/ && ./create-artifacts.sh
cd ..
docker-compose up -d
cd ..
./runChannelConfig.sh
# ./deployChaincode