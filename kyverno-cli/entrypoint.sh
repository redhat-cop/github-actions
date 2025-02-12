#!/usr/bin/env bash

set -e

exec_bats() {
  local TESTS="${1}"

  if [[ ! -f "${TESTS}" ]]; then
    echo "${TESTS} does not exist. Failing"
    exit 1
  fi

  exec bats "${TESTS}"
}

exec_raw() {
  local COMMAND="${1}"

  echo "Executing: ${COMMAND}"

  eval "${COMMAND}"
}

if [[ -z "${2}" ]]; then
  exec_bats "${1}"
else
  exec_raw "${2}"
fi
