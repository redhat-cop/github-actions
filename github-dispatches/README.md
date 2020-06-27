![Test github-dispatches](https://github.com/redhat-cop/github-actions/workflows/Test%20github-dispatches/badge.svg)

# github-dispatches GitHub Action

This action triggers a GitHub CI [dispatches event](https://blog.marcnuri.com/triggering-github-actions-across-different-repositories).

## Usage

```yaml
    - name: github-dispatches
      uses: ./github-dispatches
      with:
        username_token: ${{ secrets.REPO_TOKEN }}
        repo_array: '[{"url":"owner/repo","event_type":"Triggered","client_payload":{"customField":"customValue"}}]'
```