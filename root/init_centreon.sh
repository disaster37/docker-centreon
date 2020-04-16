#!/usr/bin/with-contenv bash

wait_centreon() {
    echo "Waiting centreon..."
    curl -sf "http://127.0.0.1/centreon/install/install.php" > /dev/null
    RT=$?
    while [ "$RT" -ne 0 ]; do
      sleep 10
      curl -sf "http://127.0.0.1/centreon/install/install.php" > /dev/null
      RT=$?
      echo "."
    done
}


if [ ! -f "/etc/crentreon/.init" ]; then
    wait_centreon
    echo "Starting setup centreon ..."
    curl -c cookie.txt http://127.0.0.1/centreon/install/install.php
    curl -b cookie.txt http://127.0.0.1/centreon/install/steps/step.php?action=nextStep
    curl -b cookie.txt http://127.0.0.1/centreon/install/steps/step.php?action=nextStep
    curl -b cookie.txt -vvv -XPOST -F "install_dir_engine=/usr/share/centreon-engine" -F "centreon_engine_stats_binary=/usr/sbin/centenginestats" -F "monitoring_var_lib=/var/lib/centreon-engine" -F "centreon_engine_connectors=/usr/lib64/centreon-connector" -F "centreon_engine_lib=/usr/lib64/centreon-engine" -F "centreonplugins=/usr/lib/centreon/plugins/" http://127.0.0.1/centreon/install/steps/process/process_step3.php
    curl -b cookie.txt http://127.0.0.1/centreon/install/steps/step.php?action=nextStep
    curl -b cookie.txt -vvv -XPOST -F "centreonbroker_etc=/etc/centreon-broker" -F "centreonbroker_cbmod=/usr/lib64/nagios/cbmod.so" -F "centreonbroker_log=/var/log/centreon-broker" -F "centreonbroker_varlib=/var/lib/centreon-broker" -F "centreonbroker_lib=/usr/share/centreon/lib/centreon-broker" http://127.0.0.1/centreon/install/steps/process/process_step4.php
    curl -b cookie.txt http://127.0.0.1/centreon/install/steps/step.php?action=nextStep
    curl -b cookie.txt -vvv -XPOST -F "admin_password=admin" -F "confirm_password=admin" -F "firstname=admin" -F "lastname=admin" -F "email=admin@no.no" http://127.0.0.1/centreon/install/steps/process/process_step5.php
    curl -b cookie.txt http://127.0.0.1/centreon/install/steps/step.php?action=nextStep
    curl -b cookie.txt -vvv -XPOST -F "address=" -F "port=" -F "root_user=root" -F "root_password=" -F "db_configuration=centreon" -F "db_storage=centreon_storage" -F "db_user=centreon" -F "db_password=centreon" -F "db_password_confirm=centreon" http://127.0.0.1/centreon/install/steps/process/process_step6.php
    curl -b cookie.txt http://127.0.0.1/centreon/install/steps/step.php?action=nextStep
    curl -b cookie.txt -vvv -XPOST http://127.0.0.1/centreon/install/steps/process/configFileSetup.php
    curl -b cookie.txt -vvv -XPOST http://127.0.0.1/centreon/install/steps/process/installConfigurationDb.php
    curl -b cookie.txt -vvv -XPOST http://127.0.0.1/centreon/install/steps/process/installStorageDb.php
    curl -b cookie.txt -vvv -XPOST http://127.0.0.1/centreon/install/steps/process/createDbUser.php
    curl -b cookie.txt -vvv -XPOST http://127.0.0.1/centreon/install/steps/process/insertBaseConf.php
    curl -b cookie.txt -vvv -XPOST http://127.0.0.1/centreon/install/steps/process/partitionTables.php
    curl -b cookie.txt -vvv -XPOST http://127.0.0.1/centreon/install/steps/process/generationCache.php
    curl -b cookie.txt http://127.0.0.1/centreon/install/steps/step.php?action=nextStep
    curl -b cookie.txt -vvv -XPOST http://127.0.0.1/centreon/install/steps/process/process_step8.php
    curl -b cookie.txt http://127.0.0.1/centreon/install/steps/step.php?action=nextStep
    curl -b cookie.txt -vvv -XPOST http://127.0.0.1/centreon/install/steps/process/process_step9.php

    echo "Setup is finished"

    touch /etc/centreon/.init
    touch /usr/share/centreon/www/install_finish.html
fi
