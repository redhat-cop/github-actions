![Test redhat-csp-download](https://github.com/redhat-cop/github-actions/workflows/Test%20redhat-csp-download/badge.svg)

# redhat-csp-download GitHub Action

This action uses [redhat-csp-download](https://github.com/sabre1041/redhat-csp-download) to download resources from the Red Hat Customer Portal,
which can be used as part of your GitHub integration tests.

## Usage

```yaml
    - name: redhat-csp-download
      uses: redhat-cop/github-actions/redhat-csp-download@master
      with:
        rh_username: ${{ secrets.RH_USERNAME }}
        rh_password: ${{ secrets.RH_PASSWORD }}
        download: '[{"file":"/github/workspace/eap-connectors.zip","url":"https://access.redhat.com/jbossnetwork/restricted/softwareDownload.html?softwareId=37193"}]'
```

### Action Volume Mapping
If you want to use your files after this action, they need to be written to a volume, such as:

    /github/workspace