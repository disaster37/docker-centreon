FROM almalinux:9

ENV \
    LANG=C.UTF-8 \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2

# Centreon
RUN \
  dnf install -y wget git &&\
  dnf install -y dnf-plugins-core &&\
  dnf install -y  epel-release &&\
  dnf config-manager --set-enabled crb &&\
  dnf module reset php &&\
  dnf module install -y php:8.2 &&\
  dnf module enable -y mariadb:10.11 &&\
  dnf config-manager --add-repo https://packages.centreon.com/rpm-standard/25.10/el9/centreon-25.10.repo &&\
  dnf clean all --enablerepo=* &&\
  dnf update -y &&\
  dnf install -y centreon-mariadb centreon &&\
  systemctl daemon-reload &&\
  dnf clean all

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


CMD ["/usr/sbin/init"]