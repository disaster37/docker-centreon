FROM centos:7

ENV \
    LANG=C.UTF-8 \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2

# Centreon
RUN \
  yum install -y wget git &&\
  yum install -y centos-release-scl &&\
  yum install -y http://yum.centreon.com/standard/19.10/el7/stable/noarch/RPMS/centreon-release-19.10-1.el7.centos.noarch.rpm &&\
  yum install -y centreon &&\
  yum clean all

# Configure Centreon
RUN \
  echo "date.timezone = Europe/Paris" > /etc/opt/rh/rh-php72/php.d/php-timezone.ini &&\
  mkdir -p  /etc/systemd/system/mariadb.service.d/ &&\
  echo -ne "[Service]\nLimitNOFILE=32000\n" | tee /etc/systemd/system/mariadb.service.d/centreon.conf &&\
  systemctl enable httpd24-httpd &&\
  systemctl enable snmpd &&\
  systemctl enable snmptrapd &&\
  systemctl enable rh-php72-php-fpm &&\
  systemctl enable centcore &&\
  systemctl enable centreontrapd &&\
  systemctl enable cbd &&\
  systemctl enable centengine &&\
  systemctl enable centreon &&\
  systemctl enable mariadb

# Install s6-overlay
ENV S6_VERSION "v1.21.2.1"
RUN curl -Lo /tmp/s6-overlay-amd64.tar.gz "https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-amd64.tar.gz" &&\
    tar xzf /tmp/s6-overlay-amd64.tar.gz -C / --exclude="./bin" --exclude="./sbin" &&\
    tar xzf /tmp/s6-overlay-amd64.tar.gz -C /usr ./bin

COPY root /
RUN systemctl enable s6-overlay

# Temporary fix API
RUN \
    cd /tmp &&\
    git clone https://github.com/disaster37/centreon.git &&\
    cd centreon &&\
    git checkout feature/getparam &&\
    rm -rf /usr/share/centreon/www/class/centreon-clapi &&\
    rm -rf /usr/share/centreon/lib/Centreon &&\
    mv www/class/centreon-clapi /usr/share/centreon/www/class/ &&\
    mv lib/Centreon /usr/share/centreon/lib/ &&\
    cd /tmp &&\
    rm -rf /tmp/centreon


# Manage persistant data
#RUN \
#    mv /etc/centreon /etc/centreon.origin &&\
#    mv /etc/centreon-engine /etc/centreon-engine.origin &&\
#    mv /etc/centreon-broker /etc/centreon-broker.origin &&\
#    mv /var/lib/mysql /var/lib/mysql.origin

#VOLUME ["/var/lib/mysql", "/etc/centreon", "/etc/centreon-engine", "/etc/centreon-broker"]

CMD ["/usr/sbin/init"]