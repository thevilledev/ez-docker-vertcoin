# ez-docker-vertcoin

Easy way to set up your own Vertcoin (VTC) node.

Includes Docker configuration for building & running VTC node in Docker. No need to install any extra build tools into your OS.

Compressed Docker image size is about 100 MB.

# Prequisites

Build requires multi-stage support from Docker, so version >= 17.05 is required.

Install docker-compose if you want to use it to set up your node. Useful for all the lazy people.

# Building

Clone this repository.

```
$ git clone https://github.com/vtorhonen/ez-docker-vertcoin.git
$ cd ez-docker-vertcoin
```

Build your own image and run:

```
$ sudo docker-compose build
$ sudo docker-compose up -d
```

Building the image takes quite a while.

If you are lazy and you trust my binaries then you can use pre-built images from [my Dockerhub repo](https://hub.docker.com/r/vtorhonen/ez-docker-vertcoin/).

```
$ sudo docker-compose up -d
```

Data directory called `data` is created to the working directory upon startup. It is then mounted to the container by default. You won't lose your wallet if you destroy the container.

Since Dockerhub doesn't support multi-stage builds yet (see issue #1) the builds are probably not as transparent as they should be. Will be fixed.

# Accessing your wallet

You can interact with your wallet by using `vertcoin-cli.sh` wrapper script. Note that blockchain syncing takes some hours to complete after container startup and it is wise to wait.

Check current sync status:

```
$ ./vertcoin-cli.sh getinfo
```

Check your wallet balance:

```
$ ./vertcoin-cli.sh getbalance
0.00000000
```

List all available CLI commands:

```
$ ./vertcoin-cli.sh help
```

# Feedback

Create a Github issue. Feedback is always welcome!
