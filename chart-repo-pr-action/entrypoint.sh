#!/bin/sh

set -e

export AUTH_TOKEN=$INPUT_AUTH_TOKEN
export AUTH_USER=${INPUT_AUTH_USER:-$GITHUB_ACTOR}
export LOCAL_CHARTS_DIR=$INPUT_LOCAL_CHARTS_DIR
export UPSTREAM_CHARTS_DIR=$INPUT_UPSTREAM_CHARTS_DIR
export FORK_NAME=$INPUT_FORK_NAME
export UPSTREAM_OWNER=$INPUT_UPSTREAM_OWNER
export COMMITTER_NAME=${INPUT_COMMITTER_NAME:-$GITHUB_ACTOR}
export COMMITTER_EMAIL=$INPUT_COMMITTER_EMAIL
export COMMIT_MESSAGE=$INPUT_COMMIT_MESSAGE
export SOURCE_BRANCH=$INPUT_SOURCE_BRANCH
export TARGET_BRANCH=$INPUT_TARGET_BRANCH

## Ensure LOCAL_CHARTS_DIR directory exists in local repo
if [ ! -d "$LOCAL_CHARTS_DIR" ]; then
  echo "ERR: directory '$LOCAL_CHARTS_DIR' does not exist"
  exit 1
fi

## Clone fork
cd ../
git clone https://$AUTH_USER:$AUTH_TOKEN@github.com/$FORK_NAME charts-fork
cd charts-fork
fork_dir=$(pwd)
git config user.name $COMMITTER_NAME
git config user.email $COMMITTER_EMAIL

## Add upstream
fork_owner=$(echo $FORK_NAME | cut -d '/' -f1)
fork_repo=$(echo $FORK_NAME | cut -d '/' -f2)
git remote add upstream https://github.com/$UPSTREAM_OWNER/$fork_repo

## Sync fork's SOURCE_BRANCH with upstream's TARGET_BRANCH
git fetch upstream
git checkout $SOURCE_BRANCH || git checkout -b $SOURCE_BRANCH
git reset --hard upstream/$TARGET_BRANCH

## For each chart in the local repo, remove that chart from the fork and then copy it over
## This essentially cleans the fork before trying to create/update the PR
cd $GITHUB_WORKSPACE/$LOCAL_CHARTS_DIR
for chart in */; do
  rm -rfv $fork_dir/$UPSTREAM_CHARTS_DIR/$chart
  cp -rv $chart $fork_dir/$UPSTREAM_CHARTS_DIR/
done

## Add, Commit, and Push
## git status is here for logging purposes. This might be useful in the early phases of this Action where issues may occur
cd $fork_dir
git status
git add --all
exit_early=true
## If there aren't any changes, exit early
## Note that this condition will close PRs that this Action opened previously since GitHub detects that there aren't any changes once we force push
## I think this is acceptable, however, since this action will automatically open a new PR once new changes are introduced
if ! git diff-index --quiet HEAD; then
  git commit -m "$COMMIT_MESSAGE"
  exit_early=false
fi
git push origin $SOURCE_BRANCH --force
if [ "$exit_early" = true ]; then
  echo "INFO: no change detected against target branch. Exiting early..."
  exit 0
fi

## Create PR
export GITHUB_USER=$COMMITTER_NAME
export GITHUB_TOKEN=$AUTH_TOKEN
## Determine if PR already exists
set +e
gh pr list --state open --base $TARGET_BRANCH --repo $UPSTREAM_OWNER/$fork_repo | grep $fork_owner:$SOURCE_BRANCH
exit_code=$?
set -e
if [ $exit_code -eq 0 ]; then
  echo "INFO: pr already exists. Exiting..."
  exit 0
else
  gh pr create --base $TARGET_BRANCH --head $fork_owner:$SOURCE_BRANCH --title "$COMMIT_MESSAGE" --body "Syncing charts from $FORK_NAME" --repo $UPSTREAM_OWNER/$fork_repo
fi