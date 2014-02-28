# This file is part of FreePBX.
#
#    FreePBX is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 2 of the License, or
#    (at your option) any later version.
#
#    FreePBX is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with FreePBX.  If not, see <http://www.gnu.org/licenses/>.
#
# FreePBX script to generate language directories in i18n folders
# Copyright (C) 2014 Schmoozecom, Inc.
# Script authored by Kevin McCoy, QLOOG Inc. rnd@qloog.com

#
#!/bin/bash

# This file is used to generate directories in module folders that contain
# an i18n directory. This usually means that they are compatible with
# gettext and can be localized.

# USAGE: ./makelangdirs.sh <language code>
# EXAMPLE: ./makelangdirs.sh ja_JP

# Test for correct usage

LANGCODE=$1
[ $# -eq 0 ] && { echo "Usage: $0 language_code"; echo "Example language code: ja_JP for Japanese, fr_FR for French..."; exit 1;}

# This dir is hardcoded for now! We might need to change this to match new
# working processes.
pushd /var/www/html/admin/

# Find directories named i18n and make a new directory based on input 
for testdir in `find . -type d -name "i18n"`
do
	[ -d $testdir/ja_JP/LC_MESSAGES ] || echo $testdir "was missing a" $LANGCODE "directory";
        [ -d $testdir/ja_JP/LC_MESSAGES ] || mkdir -p $testdir/$LANGCODE/LC_MESSAGES;	
done

popd
