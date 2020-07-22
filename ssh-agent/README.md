# SSH Agent GitHub Action

This action sets up an `ssh-agent` (including `known_hosts` and a private key) for use throughout the rest of your GitHub Workflow. This can be used if you need to SSH into any machines for deployment purposes, or if you need SSH configured for accessing any Git repositories on hosts other than GitHub.com.

> :exclamation: **All private data, including your private key and (potentially) your domain, should be stored and injected using GitHub secrets!**

## Usage

Add the following (minimal) config to a step in your GitHub Workflow:

```yaml
      - name: Set up SSH
        uses: redhat-cop/github-actions/ssh-agent@master
        with:
          domain: ${{ secrets.DOMAIN}}
          private_key: ${{ secrets.PRIVATE_KEY }}
```

Also available are `ssh_port` if you need to connect on a non-default port, and `ssh_auth_sock` if for any reason you need to specify the location of the `ssh-agent` unix socket:

```yaml
      - name: Set up SSH
        uses: redhat-cop/github-actions/ssh-agent@master
        with:
          domain: ${{ secrets.DOMAIN}}
          private_key: ${{ secrets.PRIVATE_KEY }}
          ssh_port: 1234
          ssh_auth_sock: /tmp/my_special_auth.sock
```

Here is a full example of using this action to clone a private repository from a non-GitHub host:

```yaml
jobs:
  clone-my-thing:
    runs-on: ubuntu-18.04
    steps:
      - name: Set up SSH
        uses: redhat-cop/github-actions/ssh-agent@master
        with:
          domain: gitlab.com
          private_key: ${{ secrets.GITLAB_PRIVATE_KEY }}
      - name: Clone private repo
        env:
        run: |
          git clone ssh://git@gitlab.com/my-org/my-repo.git
      - name: Show the repo
        run: |
          ls my-repo
```
