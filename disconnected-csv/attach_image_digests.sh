#!/bin/bash

set -e

SCRIPT_BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [ ! -f "${INPUT_CSV_FILE}" ]; then
  echo "ClusterServiceVersion File Not Present. Aborting"
  exit 1
fi

# CSV to be processed
CSV_FILE="${INPUT_CSV_FILE}"

# used to identify which container in the spec is the actual operator, versus
# others (e.g. the kube rbac proxy).
OPERATOR_CONTAINER_NAME="${INPUT_OPERATOR_CONTAINER_NAME:-manager}"

# any value other than "0" will trigger conversion
TAGS_TO_DIGESTS="${INPUT_TAGS_TO_DIGESTS}"

# identify environment variables with image references by this prefix
RELATED_IMAGE_ENV_PREFIX="${INPUT_RELATED_IMAGE_ENV_PREFIX:-RELATED_IMAGE_}"

source_refs=()

echo "Finding image references from container definitions..."
for img in $(yq eval '.spec.install.spec.deployments[].spec.template.spec.containers[].image' $CSV_FILE)
do
  source_refs+=( "$img" )
done


echo "Finding additional relatedImages as environment variables prefixed with \"${RELATED_IMAGE_ENV_PREFIX}\"..."
env_related_images=0
for img in $(yq eval ".spec.install.spec.deployments[].spec.template.spec.containers[].env[] | select(.name == \"${RELATED_IMAGE_ENV_PREFIX}*\") | .value" $CSV_FILE)
do
  env_related_images=$((env_related_images+1))
  source_refs+=( "$img" )
done

if [ "$env_related_images" -eq "0" ]
then
  echo "\
*************
NOTE - no related images found injected as environment variables prefixed with ${RELATED_IMAGE_ENV_PREFIX}.

If your Operator deploys an application container, it is recommended that you inject the container image reference
as an environment variable, and define this environment variable in your Operator Deployment definition 
in your ClusterServiceVersion.

Example:

containers:
  - name: operator
    image: quay.io/yourrepo/your-operator:latest
    env:
    - name: ${RELATED_IMAGE_ENV_PREFIX}APPLICATION
      value: quay.io/anotherrepo/application-image:latest

That will allow this Action to pick up your injected container reference and process it as a related image.

If your Operator does not deploy any application containers, you can safely ignore this message.
*************"
fi

# get unique refs only
sorted_unique_refs=($(echo "${source_refs[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

echo  
echo "The following refs were found:"
for ref in "${sorted_unique_refs[@]}"
do
  echo "   $ref"
done

echo
# process each image, then search and replace with sed.
for ref in "${sorted_unique_refs[@]}"
do
  echo "Processing $ref..."
 
  # if not a digest ref, skopeo inspect it.
  if ! [[ "$ref" =~ "@" ]]
  then
    img_name="${ref%%:*}"
  else
    img_name=$(echo $ref | cut -f 1 -d'@')
  fi

  echo "  Adding relatedImage..."

  python3 ${SCRIPT_BASE_DIR}/add_related_image.py $CSV_FILE $img_name $ref

  # tags to digest, and we're not already dealing with a digest ref.
  if [[ "z$TAGS_TO_DIGESTS" != "z" ]] && ! [[ "$ref" =~ "@" ]]
  then
    echo "  Processing tag to digest conversion..."
    skopeo_data=$(skopeo inspect docker://$ref)
    img_digest=$(echo $skopeo_data | jq -r '.Digest')

    echo "  Digest is $img_name@$img_digest"

    sed -i "s#$ref#$img_name@$img_digest#g" $CSV_FILE
  fi
done

echo
echo "relatedImages completed. Adding annotations..."

CREATED_TIME=`date +"%FT%H:%M:%SZ"`
operator_image=$(yq eval ".spec.install.spec.deployments[0].spec.template.spec.containers[] | select(.name == \"${OPERATOR_CONTAINER_NAME}\") | .image" "$CSV_FILE")

yq eval --inplace ".metadata.annotations.createdAt = \"${CREATED_TIME}\"" "$CSV_FILE"
yq eval --inplace ".metadata.annotations.containerImage = \"${operator_image}\"" "$CSV_FILE"

echo "Done! Resulting CSV:"
echo

cat $CSV_FILE
