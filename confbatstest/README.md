# confbatstest GitHub Action

This action uses [BATS](https://github.com/bats-core/bats-core) and [conftest](https://github.com/open-policy-agent/conftest).

## Usage

```yaml
    - name: Conftest
      uses: redhat-cop/github-actions/confbatstest@master
      with:
        tests: _test/tests.bats
```