#!/usr/bin/env bash

set -e

exec_dispatches() {
  local REPOS="${1}"
  local USRNAME_TOKEN="${2}"

  echo "${REPOS}" | jq -e "." >/dev/null 2>&1
  local jq_code=$?
  if [[ "${jq_code}" -ne 0 ]]; then
    echo "${jq_code} : Failed to parse 'repo_array' JSON. Failing"
    echo "${REPOS}"
    exit 1
  fi

  if [[ -z "${USRNAME_TOKEN}" ]]; then
    echo "USRNAME_TOKEN is empty. Skipping."
    exit 0
  fi

  for row in $(echo "${REPOS}" | jq -c ".[]"); do
    _jq() {
      echo "${row}" | jq -r -c "${1}"
    }

    echo "Attempting to trigger: ${row}"

    url=$(_jq ".url")
    data=$(_jq "{event_type: .event_type, client_payload: .client_payload}")

    HTTP_STATUS=$(curl --silent --show-error --request POST "https://api.github.com/repos/${url}/dispatches" \
      -o /dev/null -w "%{http_code}" \
      --header "Accept: application/vnd.github.everest-preview+json" \
      --user "${USRNAME_TOKEN}" \
      --data "${data}")

    if [[ "${HTTP_STATUS}" -ne 204 ]] ; then
      echo "Expected 204, got ${HTTP_STATUS} status code. Failng."
      exit 1
    fi

    echo "Completed: ${HTTP_STATUS}"
  done
}

exec_dispatches "${1}" "${2}"