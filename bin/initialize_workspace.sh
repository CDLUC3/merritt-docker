#!/usr/bin/env bash
#set -x

START_DIR=$(pwd)
SCRIPT_HOME=$(dirname $0)
WORKSPACE_DIR="$SCRIPT_HOME/.."
#WORKSPACE_BRANCH="java-refactor"
WORKSPACE_BRANCH="java-refactor.ashley"
PARENT_DIR="$WORKSPACE_DIR/.."
TESTS_DIR="$PARENT_DIR/mrt-integ-tests"
TESTS_REPO="git@github.com:cdluc3/mrt-integ-tests.git"

# Ensure workspace is clean
cd $WORKSPACE_DIR
git checkout -q $WORKSPACE_BRANCH
if [ -z "$(git status --porcelain)" ]; then
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
exit 0

echo "cloning mrt-integ-tests repo"
cd $PARENT_DIR
[-d $TESTS_DIR ] && rm -rf $TESTS_DIR
git clone $TESTS_REPO


