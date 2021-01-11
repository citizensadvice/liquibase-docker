#!/usr/bin/env bash

set -e

CUSTOM_CLASSPATH=$(find /opt/liquibase/lib-other/ -type f | xargs readlink -f | paste -sd ':')
echo "classpath: ${CUSTOM_CLASSPATH}"