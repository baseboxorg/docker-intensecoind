# IntenseCoin Node via Docker

![Stars](https://img.shields.io/docker/stars/jc21/intensecoind.svg?style=for-the-badge)
![Pulls](https://img.shields.io/docker/pulls/jc21/intensecoind.svg?style=for-the-badge)

Visit the [official IntenseCoin website](https://intensecoin.com/) to find out what it's all about.

- Based on Ubuntu image
- Using s6-overlay for process management
- Builds daemon and wallet binaries from source

**Note:** I don't keep track of [upstream code](https://github.com/valiant1x/intensecoin) changes so if you find my docker build is out of date, open a issue here on Github and I'll fire off a new build.
Please check the [latest Docker builds](https://hub.docker.com/r/jc21/intensecoind/builds/) first though.



## Up and running

With docker-compose:

```yml
version: "2"
services:
  app:
    image: jc21/intensecoind
    ports:
      - 48782:48782
      - 48772:48772
    volumes:
      - "./data/node:/root/.intensecoin"
      - "./data/wallet:/wallet"
```

With docker vanilla:

```bash
docker run --detach \
    --name intensecoind \
    -p 48782:48782 \
    -p 48772:48772 \
    -v /path/to/blockchain:/root/.intensecoin \
    -v /path/to/wallet:/wallet \
    jc21/intensecoind
```

## Using [Rancher](https://rancher.com)?

Easily start an Intense Coin Node Stack by adding [my template catalog](https://github.com/jc21/rancher-templates).


## Daemon variables

Using environment variables passed to the container you can override some defaults for the daemon:

| Variable            | Default       |
| ------------------- | ------------- |
| `LOG_LEVEL`         | `2`           |
| `P2P_BIND_IP`       | `0.0.0.0`     |
| `P2P_BIND_PORT`     | `48772`       |
| `RPC_BIND_IP`       | `127.0.0.1`   |
| `RPC_BIND_PORT`     | `48782`       |
| `DAEMON_EXTRA_ARGS` |               |

You would specify them like so:

```yml
version: "2"
services:
  app:
    image: jc21/intensecoind
    ports:
      - 48782:48782
      - 48772:48772
    environment:
      - RPC_BIND_IP=0.0.0.0
    volumes:
      - "./data/node:/root/.intensecoin"
      - "./data/wallet:/wallet"
```

Or:

```bash
docker run --detach \
    --name intensecoind \
    -p 48782:48782 \
    -p 48772:48772 \
    -e RPC_BIND_IP=0.0.0.0 \
    baseboxorg/intensecoind
```

`DAEMON_EXTRA_ARGS` is for advanced users who might want to get very specific with the daemon arguments.

You can follow the logs of the daemon with:

```bash
docker-compose logs -f app
```

Or:

```bash
docker logs -f intensecoind
```


## Wallet Access

When the docker daemon is running and in sync with the network, you can use the built in wallet-cli command:

```bash
docker-compose exec app /bin/bash -c 'cd /wallet && simplewallet'
```

Or:

```bash
docker exec -ti intensecoind /bin/bash -c 'cd /wallet && simplewallet'
```
