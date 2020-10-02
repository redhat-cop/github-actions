# chart-repo-pr-action
This action is used to copy Helm charts to a central Helm chart repository by submitting a PR to the chart repository. The below diagram depicts the intended usage of this Action.

![Diagram of chart-repo-pr-action](./images/chart-repo-pr-action.png)

## Who Is This Action For?
You might be interested in this Action if you:
* Maintain at least one Helm chart in your own repository
* Would like to publish your chart(s) to an upstream chart repository
* Would _not_ like to move your Helm chart out of your repository

This action allows you to sync Helm charts in a separate repository to an upstream chart repository without requiring you to move or copy your Helm charts manually. It copies your charts to a chart repository fork and makes a PR to the chart repository in an automated and idempotent fashion.

Interested? Read on to learn how to use this Action.

## Prerequisites
In order to use this action, you need to have the following items:
* A repository (referred to as the `local` repo) containing Helm charts you'd like to copy to a chart repository (referred to as the `upstream` repo)
* A fork of the upstream chart repository you'd like to copy your chart to
* A personal access token. See [The auth_token Parameter](#the-auth_token-parameter) section of this doc for more information.

## Basic Usage
Below shows the basic usage to include this Action in your workflow. This action is to be used in your local repo containing the Helm charts you'd like to copy.
```yaml
name: Submit PR to chart repository
on:
  push:
    branches:
      - master

jobs:
  test-job:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: redhat-cop/github-actions/chart-repo-pr-action@master
        with:
          auth_token: ${{ secrets.PAT }}
          fork_name: deweya/helm-charts
          upstream_owner: redhat-cop
          committer_email: deweya964@gmail.com
```
The `auth_token`, `fork_name`, and `upstream_owner` parameters are required. The `committer_email` parameter is optional, but is recommended.

See the next section for additional parameters.

## Parameters
| Parameter | Description | Default | Required? |
| --------- | ----------- | ------- | --------- |
| `auth_token` | Token used for authentication to push to fork | - | true |
| `fork_name` | Name of your Helm charts fork (ex: deweya/helm-charts) | - | true |
| `upstream_owner` | Owner of the upstream Helm charts repo (ex: redhat-cop) | - | true |
| `auth_user` | Username used for authentication to push to fork. | Defaults to the user who triggered the action | false |
| `local_charts_dir` | Charts directory name in local repo | `charts` | false |
| `upstream_charts_dir` | Charts directory name in upstream repo | `charts` | false |
| `committer_name` | The GitHub username to use as the committer name. | Default to the user who triggered the action | false |
| `committer_email` | The email to use as the committer email | `<>` | false |
| `commit_message` | Commit message to use when pushing to fork | `Syncing local charts with upstream chart repo` | false |
| `source_branch` | New or existing branch the action should use as the source branch for the PR | `feat/sync` | false |
| `target_branch` | Branch that the PR should target | `master` | false |

### The `auth_token` Parameter
This parameter requires special attention. It is used to authenticate with your fork so that the action can push to it and then create a PR to the upstream repo.

It is recommended to create a `Personal Access Token` (or `PAT`). [This doc](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token#creating-a-token) describes how you can create a PAT.

**NOTE:** Be sure to grant your PAT the following permissions at a minimum:
* public_repo
* read:discussion

Once you have created your PAT, you should create a secret in your repository containing your Helm chart(s). [This doc](https://docs.github.com/en/free-pro-team@latest/actions/reference/encrypted-secrets#creating-encrypted-secrets-for-a-repository) describes how you can create a secret.

Once you have created a secret, you can refer to it in your workflow like this:
```yaml
${{ secrets.PAT }}
```

Of course, be sure to use a different name other than `PAT` if you gave your secret a different name.

### The `source_branch` Parameter
One important thing to call out about the `source_branch` parameter is that this action will make a **force push** against this branch. As a result, it is highly recommended that you select a branch that only the action will modify. If you attempt to make changes to this branch, they will be wiped out when this action runs.

The force push is necessary because this action synchronizes your `source_branch` with the upstream's `target_branch` in order to produce an accurate diff. Since it is possible that this will rewrite `source_branch`'s history, this action performs a force push.