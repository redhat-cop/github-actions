![Test confbatstest](https://github.com/redhat-cop/github-actions/workflows/Test%20confbatstest/badge.svg)

# confbatstest GitHub Action

This action uses [BATS](https://github.com/bats-core/bats-core) and [conftest](https://github.com/open-policy-agent/conftest).
It also contains several tools which are used for JSON and YAML manipulation:
- helm
- jq
- yq

## Usage

```yaml
    - name: Conftest
      uses: redhat-cop/github-actions/confbatstest@master
      with:
        tests: _test/conftest.sh
```
