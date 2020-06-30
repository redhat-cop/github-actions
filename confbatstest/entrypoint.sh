#!/bin/bash

set -e

TESTS=$1
POLICIES=$2

mkdir -p policy

for row in $(echo "${POLICIES}" | jq -c '.[]'); do
  _jq() {
    echo ${row} | jq -r ${1}
  }

  name=$(_jq '.name')
  url=$(_jq '.url')

  conftest pull ${url} --policy ${name}

  for file in $(ls ${name}/*.rego | xargs) ; do
    cp ${file} policy/${file////_}
  done

  rm -rf ${name}
done

if [ $(ls policy/ | wc -l) -lt 1 ]; then
  echo "No policies found. Failing."
  exit 1
fi

ls -lrt policy/

exec bats ${TESTS}