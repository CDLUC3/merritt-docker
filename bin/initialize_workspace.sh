#!/usr/bin/env bash
#set -x

START_DIR=$(pwd)
SCRIPT_HOME=$(dirname $0)
WORKSPACE_DIR=$(realpath $SCRIPT_HOME/..)
PARENT_DIR=$(realpath $WORKSPACE_DIR/..)
#WORKSPACE_BRANCH="java-refactor"
WORKSPACE_BRANCH="java-refactor.ashley"
TESTS_DIR="$PARENT_DIR/mrt-integ-tests"
TESTS_REPO="git@github.com:cdluc3/mrt-integ-tests.git"

# Ensure workspace is clean
echo "Initializing Merritt Workpace: $WORKSPACE_DIR"
echo "Repository branch: $WORKSPACE_BRANCH"
cd $WORKSPACE_DIR
git checkout -q $WORKSPACE_BRANCH
if [ -z "$(git status --porcelain --ignore-submodules)" ]; then
  echo
  echo "Working directory clean"
else
  echo
  echo "ERROR: $(basename $0): Uncommitted changes in working tree."
  echo "Please clean up your working tree and re-run this script."
  echo "Use 'git status' to see uncommited changes."
  exit 2
fi

echo
echo "Updating submodules..."
git submodule update --remote --recursive --init -- .
git submodule status

echo
echo "cloning mrt-integ-tests repo"
[ -d $TESTS_DIR ] && rm -rf $TESTS_DIR
cd $PARENT_DIR
git clone $TESTS_REPO


