![Test kyverno-cli](https://github.com/redhat-cop/github-actions/workflows/Test%20kyverno-cli/badge.svg)

# kyverno-cli GitHub Action (NOT MAINTAINED)

This action uses [BATS](https://github.com/bats-core/bats-core) and [kyverno](https://github.com/kyverno/kyverno).
It also contains several tools which are used for JSON and YAML manipulation:
- helm
- jq
- yq
- oc

## Usage
Execute a BATS file which contains kyverno tests.
```yaml
    - name: kyverno
      uses: redhat-cop/github-actions/kyverno-cli@master
      with:
        tests: _test/kyverno.sh
```

Execute a command, such as `kyverno apply`:
```yaml
    - name: kyverno
      uses: redhat-cop/github-actions/kyverno-cli@master
      with:
        raw: konstraint doc -o POLICIES.md
```