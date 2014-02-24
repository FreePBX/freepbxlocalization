#/bin/bash
# Usage: the first variable passed is the xx_XX language code that you want to gather
# Example: ./gatherlangfiles.sh ja_JP
# This script will make a directory with this code and put all the files together in one directory so they can be read by Weblate
echo 'Creating directory' $1 '...'
mkdir $1;
echo 'Done, gathering all' $1 'language files installed in /var/www/html/ ...'

for pathtofile in `locate /var/www/html/*$1/LC_MESSAGES/*.po`
do
	#echo $pathtofile;
	#echo 'Yeah bro!';
	cp -v $pathtofile ./$1/;
done
echo ''
echo 'All finished!'
