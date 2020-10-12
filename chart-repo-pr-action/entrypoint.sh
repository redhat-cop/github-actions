#!/bin/sh

set -e

export AUTH_TOKEN=$INPUT_AUTH_TOKEN
export AUTH_USER=${INPUT_AUTH_USER:-$GITHUB_ACTOR}
export CHART_REPO=$INPUT_CHART_REPO
export FORK_OWNER=$INPUT_FORK_OWNER
export LOCAL_CHARTS_DIR=$INPUT_LOCAL_CHARTS_DIR
export CENTRAL_CHARTS_DIR=$INPUT_CENTRAL_CHARTS_DIR
export COMMITTER_NAME=${INPUT_COMMITTER_NAME:-$GITHUB_ACTOR}
export COMMITTER_EMAIL=$INPUT_COMMITTER_EMAIL
export COMMIT_MESSAGE=$INPUT_COMMIT_MESSAGE
export HEAD_BRANCH=$INPUT_HEAD_BRANCH
export BASE_BRANCH=$INPUT_BASE_BRANCH

## Ensure LOCAL_CHARTS_DIR directory exists in local repo
if [ ! -d "$LOCAL_CHARTS_DIR" ]; then
  echo "ERR: directory '$LOCAL_CHARTS_DIR' does not exist"
  exit 1
fi

## Clone chart repo or forked repo, depending on if fork_owner was provided or not
cd ../
if [ -z $FORK_OWNER ]; then
  clone_repo=$CHART_REPO
else
  chart_repo_name=$(echo $CHART_REPO | cut -d '/' -f2)
  clone_repo=$FORK_OWNER/$chart_repo_name
fi
git clone https://$AUTH_USER:$AUTH_TOKEN@github.com/$clone_repo repo
cd repo
repo_dir=$(pwd)
git config user.name $COMMITTER_NAME
git config user.email $COMMITTER_EMAIL

## Reset the HEAD_BRANCH to BASE_BRANCH
git checkout $HEAD_BRANCH || git checkout -b $HEAD_BRANCH
git remote add central https://github.com/$CHART_REPO
git fetch central
git reset --hard central/$BASE_BRANCH

## For each chart in the HEAD_BRANCH, remove that chart and then copy it back over
## This essentially cleans the HEAD_BRANCH before trying to create/update the PR
cd $GITHUB_WORKSPACE/$LOCAL_CHARTS_DIR
for chart in */; do
  rm -rfv $repo_dir/$CENTRAL_CHARTS_DIR/$chart
  cp -rv $chart $repo_dir/$CENTRAL_CHARTS_DIR/
done

## Add, Commit, and Push
## git status is here for logging purposes.
cd $repo_dir
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
  echo "INFO: no change detected against BASE_BRANCH. Exiting early..."
  exit 0
fi

## Create PR
export GITHUB_USER=$COMMITTER_NAME
export GITHUB_TOKEN=$AUTH_TOKEN
head_owner=$(echo $clone_repo | cut -d '/' -f1)
if [ -z $FORK_OWNER ]; then
  head=$HEAD_BRANCH
  ## Match a string like feat/sync, not deweya:feat/sync
  regex='(?<!:)'"$HEAD"
else
  head=$FORK_OWNER:$HEAD_BRANCH
  ## Match a string like deweya:feat/sync
  regex=$head
fi
## Determine if PR already exists. Grep is required since gh pr list doesn't let you filter on the head branch
set +e
gh pr list --state open --base $BASE_BRANCH --repo $CHART_REPO | grep -P $regex
exit_code=$?
set -e
if [ $exit_code -eq 0 ]; then
  echo "INFO: pr already exists. Exiting..."
  exit 0
else
  gh pr create --base $BASE_BRANCH --head $head --title "$COMMIT_MESSAGE" --body "Syncing charts from $head" --repo $CHART_REPO
fi