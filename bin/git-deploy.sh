#!/bin/sh

export IDENTITY_FILE="`mktemp /tmp/tmp.XXXXXXXXXX`"
echo "$GITHUB_KEY" >"$IDENTITY_FILE"
echo "$GITHUB_PUBLIC_KEY" >"$IDENTITY_FILE.pub"
export GIT_SSH="$( cd "$( dirname "$0" )" && pwd )/git-ssh.sh"

GIT_URL=$1
HEROKU_URL=$2
BRANCH=$3
REPO=`mktemp -d /tmp/tmp.XXXXXXXXXX`

echo "Deploying from $GIT_URL to $HEROKU_URL"

git clone $GIT_URL $REPO
cd $REPO
git checkout $BRANCH
git pull origin $BRANCH
git remote add heroku $HEROKU_URL
git push -f heroku $BRANCH:master

EXIT_STATUS=$?

echo "Cleaning up"

rm -f "$IDENTITY_FILE"
rm -f "$IDENTITY_FILE.pub"
rm -rf $REPO

exit $EXIT_STATUS
