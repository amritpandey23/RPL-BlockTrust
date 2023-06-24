# RPL-BlockTrust

## System Setup and Installation of Tools

### Tools required

- Ubuntu (latest >= 20.0) or Ubuntu WSL in Windows
- Go Programming Language [Install Guide](https://go.dev/doc/install)
- Necessary tools: (`sudo apt install build-essential doxygen git git-lfs curl wireshark python3-serial srecord rlwrap`)
- Docker: Follow step by step as given below(run them in the terminal as follows):
1. `for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done`
2. `sudo apt-get update`
3. `sudo apt-get install ca-certificates curl gnupg`
4. `sudo install -m 0755 -d /etc/apt/keyrings`
5. `curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg`
6. `sudo chmod a+r /etc/apt/keyrings/docker.gpg`

7.```echo \
"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null```

8. `sudo tee /etc/apt/sources.list.d/docker.list > /dev/null`
9. sudo apt-get update
10. `sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose`
11. `sudo docker run hello-world`

Check if Docker is installed by running this command:

```
docker --version
docker-compose --version
```

- Java SE 11: Download the binaries:
    1. `curl -LO https://corretto.aws/downloads/latest/amazon-corretto-11-x64-linux-jdk.tar.gz`
    2. Extract the tar.gz file and add the bin folder inside this folder to the `$PATH` variable in the `.bashrc` file.
    3. Check the installation by `javac --version`


### Hyperledger Fabric Setup

You can follow the Hyperledger fabric installation by following this tutorial: [https://hyperledger-fabric.readthedocs.io/en/latest/install.html](https://hyperledger-fabric.readthedocs.io/en/latest/install.html). Go step by step without leaving anything.

### ContikiNG Setup

Follow the ContikiNG setup [here](https://docs.contiki-ng.org/en/develop/doc/getting-started/Toolchain-installation-on-Linux.html#install-development-tools-for-contiki-ng).


## System Simulation

### Docker Up

1. Start the docker system by running this file: `./start_system.sh`. Make sure you make this file runnable by doing `chmod 744 start_system.sh`.
2. 

### Running ContikiNG

1. Install the `tunslip6` inside of the `serial-io` folder of the `contiki-ng` folder cloned from the repository by running `make` inside of it.
2. Run the cooja simulator by going inside of the `contiki-ng/tools/cooja` and running `./gradlew run` command.
3. Create a sample attack simulation by adding motes from the `RPL-UDP` folder in examples directory. You can check how to create a simulation by watching this tutorial on youtube [https://www.youtube.com/watch?v=pAc6yvEpx74](https://www.youtube.com/watch?v=pAc6yvEpx74).
4. Use the `mallicious.c` file to create a mallicious node. Modify it according to your needs.
5. Run the `start_simuation.c` file before starting the attack simulation in `cooja`.

> The modified files are availabe in the `Contiki` folder in this repository.
