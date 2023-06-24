cd artifacts/channel && ./create-artifacts.sh && cd ..
sleep 2
docker-compose up -d && cd ..
sleep 5
./runChannelConfig.sh
sleep 5
./deployChaincode.sh
sleep 2
echo -e "system setup completed successfully"
docker ps -a
sleep 20 
cd artifacts && ./registerPeer2.sh && cd ..
sleep 10
./stop_docker.sh
