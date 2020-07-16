# Set Helm Version GitHub Action

Given the path to a directory containing a Helm `Chart.yaml`, sets the `version` and `appVersion` of the chart to the specified values. Used to programmatically edit version numbers before a release - preserving existing structure and comments inside of the `Chart.yaml`.

## Usage

Add the following to a step in your GitHub Workflow:

```yaml
    - uses: redhat-cop/github-actions/set-helm-version@master
      with:
        path: .
        chart_version: 1.0.0
        app_version: 1.0.0
```

## Future

It would be reasonable to add parsing and automatic bumping of existing semantic versions based on keywords like "major", "minor", or "rc".
