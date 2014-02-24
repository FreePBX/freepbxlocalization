#!/bin/bash

cd /var/www/html/admin/
for testdir in `find . -type d -name "i18n"`
do
	[ -d $testdir/ja_JP/LC_MESSAGES ] || echo $testdir "was missing a Japanese i18n directory";
        [ -d $testdir/ja_JP/LC_MESSAGES ] || mkdir -p $testdir/ja_JP/LC_MESSAGES;	
done
