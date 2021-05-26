# Set to the dashpay/docs branch containing the version to update
DOC_VERSION=0.17.0

# Checkout correct branch and pull changes
git fetch
git checkout $DOC_VERSION
git pull upstream $DOC_VERSION

# Make files needed by sphinx-intl
rm -r _build
make gettext 2>&1 | tee /tmp/makelog_$$.log
if [ $PIPESTATUS -ne 0 ]; then echo "make failed, bailing out...";exit 1 ;fi
grep ": WARNING: " /tmp/makelog_$$.log
if [ $? -eq 0 ]; then echo "make issued a WARNING, bailing out...";exit 2;fi

# Update files for all languages
sphinx-intl update -p _build/gettext -l de -l pt -l ko -l el -l ar -l ru -l zh_CN -l fr -l es -l ja -l vi -l zh_TW -l it -l tl
sphinx-intl update -l en
sphinx-intl update-txconfig-resources --pot-dir locale/pot --transifex-project-name dash-docs

# Push to Transifex
tx push --source --force --no-interactive
