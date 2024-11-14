#!/bin/bash

STATE=$1
NOW=$(date +"%D %T")
KEEPALIVED="/etc/keepalived"
LOGFILE="/var/log/kamailio.log"


log_message() {
    echo "$NOW $1" | tee -a $LOGFILE
}

case $STATE in
    "MASTER")
        touch $KEEPALIVED/MASTER
        echo "$NOW Becoming MASTER" >> $KEEPALIVED/COUNTER
        log_message "Becoming MASTER - Starting kamailio service"
        systemctl start kamailio
        exit 0
        ;;

    "BACKUP")
        truncate -s0 $KEEPALIVED/MASTER
        echo "$NOW Becoming BACKUP" >> $KEEPALIVED/COUNTER
        log_message "Becoming BACKUP - Stopping kamailio service"
        systemctl stop kamailio
        exit 0
        ;;

    "FAULT")
        truncate -s0 $KEEPALIVED/MASTER
        echo "$NOW Becoming FAULT" >> $KEEPALIVED/COUNTER
        log_message "Becoming FAULT - Stopping kamailio service"
        systemctl stop kamailio
        exit 0
        ;;

    *)
        echo "unknown state"
        echo "$NOW Becoming UNKNOWN" >> $KEEPALIVED/COUNTER
        log_message "Becoming UNKNOWN - Unknown state"
        exit 1
        ;;
esac
