#!/usr/bin/env bash

set -e

RH_USERNAME=$1
RH_PASSWORD=$2
DOWNLOAD=$3

if [ -z "${RH_USERNAME}" ] || [ -z "${RH_PASSWORD}" ]
then
  echo "RH_USERNAME or RH_PASSWORD is empty. Skipping."
  exit 0
fi

if [ -z "${DOWNLOAD}" ]
then
  echo "DOWNLOAD is empty. Failing."
  exit 1
fi

pushd /ansible
ansible-galaxy install -r requirements.yml
ansible-playbook download.yml -e rh_username=${RH_USERNAME} -e rh_password=${RH_PASSWORD} -e download=${DOWNLOAD}
popd