#!/usr/bin/env bash

bareos_fd_config="/etc/bareos/bareos-fd.d/director/bareos-dir.conf"

if [ ! -f /etc/bareos/bareos-config.control ]; then

  # Read client/file deamon password from docker secret
  if [ -n "${BAREOS_FD_PASS_SECRET:+set}" ]; then
    BAREOS_FD_PASSWORD=$(cat "/run/secrets/${BAREOS_FD_PASS_SECRET}")
  fi
  # Force client/file daemon password
  sed -i 's#Password = .*#Password = '\""${BAREOS_FD_PASSWORD}"\"'#' $bareos_fd_config

  # Control file
  touch /etc/bareos/bareos-config.control
fi

# Fix permissions
find /etc/bareos/bareos-fd.d ! -user bareos -exec chown bareos {} \;

# Run Dockerfile CMD
exec "$@"
