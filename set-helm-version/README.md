# Set Helm Version GitHub Action

Given the path to a directory containing a Helm `Chart.yaml`, sets the version and appVersion of the chart to the specified values. Used to automatically edit version numbers before a release.

## Usage

Add the following to a step in your GitHub Workflow:

```yaml
    - uses: redhat-cop/github-actions/set-helm-version@master
      with:
        path: .
        chart_version: 1.0.0
        app_version: 1.0.0
```
