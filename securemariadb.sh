#!/bin/bash
set -e

mariadb-secure-installation <<EOF

Y
Y
root
root
Y
n
Y
Y
EOF