#!/bin/bash

# Set to the dashpay/docs branch containing the version to update
DOC_VERSION=master

DAY=$(date +%d)
MONTH=$(date +%m)
YEAR=$(date +%Y)
TIME=$(date +%H)$(date +%M)
BRANCH_NAME=chore/translation-update-$YEAR-$MONTH-$DAY-$TIME

# Checkout branch then create a new branch for updates after pulling changes
git checkout $DOC_VERSION
git pull
git checkout -b $BRANCH_NAME

# Pull Transifex changes for all defined languages
for x in de pt ko el ar ru zh_CN zh_TW it fr es ja vi tl
do
	echo $x
	tx pull -f -l $x&
done
while sleep 1;do procs=$(ps aux);echo "$procs"|grep -q "tx pull -f -l"||break;done
echo "tx pulls are all done now."

# Add changes to repo and push to upstream so a pull request can be opened
git add locale/*
git commit -m "Refresh translations from Transifex"
git push --set-upstream origin $BRANCH_NAME

# Create PR automatically if GitHub CLI is installed (https://cli.github.com/)
gh pr create --title "chore: refresh translations from transifex" --body "Latest updates from Transifex based on running the [transifex/pulltx.sh](https://github.com/dashpay/docs/blob/master/transifex/pulltx.sh) script."
