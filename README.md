# Repository Layout

This repository contains:
- standalone GitHub Actions that can be called from your workflows
- example workflows that you can copy into your own repositories

## Included in this repo:

### Actions
- [confbatstest](/confbatstest)
- [github-dispatches](/github-dispatches)
- [redhat-csp-download](/redhat-csp-download)
- [s2i](/s2i)

### Workflows

## Contributing

If you would like to contribute to this repository, you can do one of the following:

### GitHub Action

If you have an action that you'd like to contribute, you can create a directory at the root of the repository and then create your action inside of there. This would look something like:

```sh
/my-awesome-action
  - action.yml
  - entrypoint.sh
  ... etc.
```

We're looking to keep the individual GitHub Actions at the root of this repository as it reduces the complexity of importing them into external workflows.

### Workflows

If you have an example workflow that you would like to contribute, you can similarly create a new directory under the existing `workflows` directory. From there you can then add your content and descriptions, etc.

**Note:** For workflows, we're looking for something more than you can find in individual `how-to's` for a single action. The ideal workflow example would be pulling together sets of actions or multiple workflows to accomplish a larger goal.
