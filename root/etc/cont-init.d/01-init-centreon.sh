#!/usr/bin/with-contenv sh
if [ ! -f "/etc/crentreon/.init" ]; then
    echo "Starting init centreon..."
    #cp -a /etc/centreon.origin/* /etc/centreon/
    #cp -a /etc/centreon-engine.origin/* /etc/centreon-engine/
    #cp -a /etc/centreon-broker.origin/* /etc/centreon-broker/
    #cp -a /var/lib/mysql.origin/* /var/lib/mysql/
    echo "Init centreon finished"
fi