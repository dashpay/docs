DAY=$(date +%d)
MONTH=$(date +%m)
YEAR=$(date +%Y)
TIME=$(date +%H)$(date +%M)

git checkout 0.17.0
git pull
git checkout -b chore/translation-update-$YEAR-$MONTH-$DAY-$TIME

for x in de pt ko el ar ru zh_CN zh_TW it fr es ja vi tl
do
	echo $x
	tx pull -f -l $x&
done
while sleep 1;do procs=$(ps aux);echo "$procs"|grep -q "tx pull -f -l"||break;done
echo "tx pulls are all done now."

git add locale/*
git commit -m "Refresh translations from Transifex"
git push --set-upstream origin chore/translation-update-$YEAR-$MONTH-$DAY-$TIME
