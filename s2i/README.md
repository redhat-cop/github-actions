# Source-to-Image (S2I) GitHub Action

This action uses [Source2Image](https://github.com/openshift/source-to-image) to build container
images from source. After the image is built, it will automatically be pushed to a desired
image registry.

## Usage

Add the following to a step in your GitHub Workflow:

```yaml
    - uses: redhat-cop/github-actions/s2i@master
      with:
        base: registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift
        output_image: quay.io/my-org/my-repo:latest
        image_pull_registry: registry.access.redhat.com
        image_pull_username: ${{ secrets.RHT_REGISTRY_USERNAME }}
        image_pull_password: ${{ secrets.RHT_REGISTRY_PASSWORD }}
        image_push_registry: quay.io
        image_push_username: ${{ secrets.QUAY_USERNAME }}
        image_push_password: ${{ secrets.QUAY_PASSWORD }}
```

If the image registry hosting your builder/base image is public, you may omit `image_pull_registry`,
`image_pull_username` and `image_pull_password`. In keeping with best practice, your credentials
should be stored in secrets and consumed as shown - not added directly to your workflow yaml.

## Credit

This action was originally based on Vadim Rutkovsky's [action-s2i](https://github.com/vrutkovs/action-s2i).
