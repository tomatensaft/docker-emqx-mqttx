# docker-emqx-mqttx :twisted_rightwards_arrows:
docker EMQX broker with MQTTX websocket client

## contents
* [installation](#installation)
* [usage](#usage)
* [tests](#tests)
* [version](#version)

## installation
* install docker for linux or wsl
* adjust environment settings for and `.env`
* test configuration with `setup-emqx-mqttx.sh --test`
* docker compose configuration you will find `docker-compose.yml` 
* emqx dashboard (e.g. http://localhost:18083)
* mqttx webcient (e.g. http://localhost:80)
* important, whin is not working -> not subcribe to tpoic with `#`
  
## usage 
* setup docker container for testing
  - `setup-emqx-mqttx.sh --setup` 
* docker compose start emqx
  - `setup-emqx-mqttx.sh --start`
* docker compose stop emqx
  - `setup-emqx-mqttx.sh --stop`
* docker compose reset emqx
  - `setup-emqx-mqttx.sh --reset`
* delete all docker and configuration data
  - `setup-emqx-mqttx.sh --delete`
* state of docker container
  - `setup-emqx-mqttx.sh --state`

## resources
* debug examples [debug](debug/)
* emqx files [grafana](emqx/)

## tests
* not testet completly
  
---
## version
*[v0.1.0]*
