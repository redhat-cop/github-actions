#!/bin/bash

set -e

TESTS=$1

mkdir policy

conftest pull github.com/redhat-cop/rego-policies.git//policy --policy redhat-cop
cp redhat-cop/*.rego policy

conftest pull github.com/swade1987/deprek8ion.git//policies --policy deprek8ion
cp deprek8ion/*.rego policy

bats ${TESTS}