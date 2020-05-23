#!/bin/bash

#Nedd to run as superuser

CRON_FILE="docker-stats-cron"

touch $CRON_FILE

echo "* * * * * root cd $(pwd) && ./script.sh" > $CRON_FILE

# Install cron
echo "Move $CRON_FILE to /etc/cron.d"
chown root:root $CRON_FILE
chmod 644 $CRON_FILE
mv $CRON_FILE /etc/cron.d/

