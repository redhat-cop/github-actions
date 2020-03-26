#!/bin/bash

set -e

# Set named vars
SRC=$1
BASE=$2
OUTPUT_IMAGE=$3
IMAGE_PULL_REGISTRY=$4
IMAGE_PULL_USERNAME=$5
IMAGE_PULL_PASSWORD=$6
IMAGE_PUSH_REGISTRY=$7
IMAGE_PUSH_USERNAME=$8
IMAGE_PUSH_PASSWORD=$9
IMAGE_TAGS=${10}

if [ -z $IMAGE_PULL_USERNAME ]; then
    echo "Skipping login for image pull - username not set."
else
    echo "Credentials for builder image registry detected - logging in."
    echo "${IMAGE_PULL_PASSWORD}" | docker login "${IMAGE_PULL_REGISTRY}" --username "${IMAGE_PULL_USERNAME}" --password-stdin
fi
# We will always need to login to the registry we intend to push to
echo "${IMAGE_PUSH_PASSWORD}" | docker login "${IMAGE_PUSH_REGISTRY}" --username "${IMAGE_PUSH_USERNAME}" --password-stdin
# Grab builder image
docker pull "${BASE}"
# Build
s2i build "${SRC}" "${BASE}" "${OUTPUT_IMAGE}"
# Push to output registry
docker push "${OUTPUT_IMAGE}"
# Add additional tags
echo "Adding additional tags"
for tag in $(echo $IMAGE_TAGS|sed -e 's/ //g' -e 's/,/ /g'); do
  TAG=$(echo $OUTPUT_IMAGE|cut -d: -f1):${tag}
  echo "Tagging ${OUTPUT_IMAGE} as ${TAG}"
  docker tag $OUTPUT_IMAGE $TAG
  echo "Pushing ${TAG}"
  docker push $TAG
done
