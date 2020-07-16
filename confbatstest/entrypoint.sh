#!/usr/bin/env bash

set -e

exec_bats() {
  local TESTS="${1}"
  local POLICIES="${2}"

  if [[ ! -f "${TESTS}" ]]; then
    echo "${TESTS} does not exist. Failing"
    exit 1
  fi

  echo "${POLICIES}" | jq -e "." >/dev/null 2>&1
  local jq_code=$?
  if [[ "${jq_code}" -ne 0 ]]; then
    echo "${jq_code} : Failed to parse 'policies' JSON. Failing"
    echo "${POLICIES}"
    exit 1
  fi

  mkdir -p policy

  for row in $(echo "${POLICIES}" | jq -c ".[]"); do
    _jq() {
      echo "${row}" | jq -r "${1}"
    }

    name=$(_jq ".name")
    url=$(_jq ".url")

    conftest pull "${url}" --policy "${name}"

    # shellcheck disable=SC2038
    for file in $(find "${name}"/* -name "*.rego" -type f | xargs) ; do
      cp "${file}" "policy/${file////_}"
    done

    rm -rf "${name}"
  done

  if [ "$(find policy/* -name "*.rego" -type f | wc -l)" -lt 1 ]; then
    echo "No policies found. Failing."
    exit 1
  else
    find policy/* -name "*.rego" -type f
  fi

  exec bats "${TESTS}"
}

exec_bats "${1}" "${2}"