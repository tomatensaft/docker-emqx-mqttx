#!/bin/sh

#set -x

# set absolute path of root app for global use
SCRIPT_ROOT_PATH=$(pwd)

# include external libs from git submodule
if [ -f  ./posix-lib-utils/standard_lib.sh ]; then
    . ./posix-lib-utils/docker_lib.sh
else
    printf "$0: external libs not found - exit."
    exit 1
fi

#print header
print_header "setup emqx/mqttx"

#load enviroment variables
log -info "load environment variables"
. ./.env

#print verion
log -info "version of historian setup ${DOCKER_GENERAL_VERSION}"

#Check number of args
check_args 1

#Parameter/Arguments
option=$1

# main functions
main() {

    # check inputargs
    case $option in
            --test)
                log -info "test Command for debugging $0\n"
                test_configuration
                ;;

            --setup)
                log -info "setup emqx"
                check_requirements
                docker_setup_images
                ;;

            --start)
                check_requirements
                log -info "start emqx."
                docker_compose_start
                ;;

            --stop)
                check_requirements
                log -info "stop emqx"
                docker_compose_stop
                ;;

            --reset)
                check_requirements
                log -info "reset emqx"
                docker_compose_reset
                ;;

            --delete)
                check_requirements
                log -info "delete emqx data"
                docker_delete_data
                docker_delete_local_data
                ;;

            --state)
                docker_check_state
                ;;

            --help | --info | *)
                usage   "\-\-test:              test command" \
                        "\-\-setup:             setup emqx/mqttx" \
                        "\-\-start:             start container" \
                        "\-\-stop:              stop container" \
                        "\-\-reset:             reset container" \
                        "\-\-delete:            delete docker data" \
                        "\-\-state:             state of docker system" \
                        "\-\-help:              help"
                ;; 
    esac
}


#setup docker images
docker_setup_images() {

    log -info "setup docker images"

    # convert relative path to absolute
    log -info "convert raltive to absolute path docker emqx"
    DOCKER_MQTT_VOLUME=$(echo ${DOCKER_MQTT_VOLUME} | sed -e  's|^./|'"$(pwd)/"'|g')

    # docker mosquitto image
    log -info "docker emqx"
    docker run -d \
        -p ${DOCKER_MQTT_BROKER_PORT}:1883 -p ${DOCKER_MQTT_WEBSOCKET_PORT}:8084 \
        -p ${DOCKER_MQTT_BROKER_SSL_PORT}:8883 -p ${DOCKER_MQTT_WEBSOCKET_SSL_PORT}:8083 \
        -p ${DOCKER_MQTT_DASHBOARD_PORT}:18083 \
        --name emqx-broker \
        -v ${DOCKER_MQTT_VOLUME}/data:/opt/emqx/data \
        -v ${DOCKER_MQTT_VOLUME}/log:/opt/emqx/log \
        --env-file ".env" \
        emqx:latest

    sleep 2
    docker ps -a
    printf "was docker emqx successful ?"
    continue_yes_no

    #docker mqttx image
    log -info "docker mqttx"
    docker run -d \
        -p ${DOCKER_MQTT_WEBCLIENT_PORT}:80 \
        --name mqttx-web-client \
        --env-file ".env" \
        emqx/mqttx-web:latest

    sleep 2
    docker ps -a
    log -info "was docker mqttx successful ?"
    log -info "check installation http://localhost:80/"
    continue_yes_no

}


#delete productive files
docker_delete_local_data() {

    log -info "delete prductive data\n"

    #remove mosquitto data
    if [ -d ${DOCKER_MQTT_VOLUME} ] && \
        [ ! ${DOCKER_MQTT_VOLUME} = "/" ] && \
        [ ! -z ${DOCKER_MQTT_VOLUME} ]; then
            log -info "delete files in ${DOCKER_MQTT_VOLUME}\n"
            rm -r ${DOCKER_MQTT_VOLUME}/data/*
            rm -r ${DOCKER_MQTT_VOLUME}/log/*
    fi


}

#Check requirements
check_requirements() {

    #check root
    check_root

    #Check Command
    if command -v docker >/dev/null 2>&1 ; then
        log -info "docker found OK"
    else
        log -info "docker not found MISSING"

        #install docker system or abort
        log -info "install docker system [y] or abort [n] setup ?"
        continue_yes_no
        docker_setup_system
    fi 
}

#call main Function manually - if not need uncomment
main "$@"; exit