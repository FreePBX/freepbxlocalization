#!/bin/bash
#   This script compiles .po files as binary .mo files and copies them to the appropriate locations on the FreePBX distro.
#   I'm sorry, but you have to run it as root. Maybe Dave can think of a more elegant way to do this.
#   First, we will compile the .po files into .mo files.
#   This command includes the -f flag to include fuzzy strings
#   

#   Usage: ./update_xlation.sh <langcode>
#   Example: ./update_xlation.sh ja_JP

# Define language code
LANGCODE=$1
# Use the working directory as a variable later on so we know where to come back to
WORKDIR=`pwd`

# First we check for correct usage
[ $# -eq 0 ] && { echo "Usage: $0 language_code"; echo "Example language code: ja_JP for Japanese, fr_FR for French..."; exit 1;}

echo "Compiling .po files into .mo binaries for use…"
pushd po/ja;
for pofile in `find . -name "*.po"`; do 
	# FNAME is "./<pofilenamehere>" without its .po extension
	FNAME=${pofile%.po}; 
	# Compile an mo binary using $FNAME.mo
	msgfmt -f -v $pofile -o ${FNAME}.mo; 
	#echo $fname "This is fname";
	# Go to the installation directory - we might need to change this
	# depending on how we work with these files
	pushd /var/www/html/;
	# Find ./admin/modules/$FNAME (with no ./ in front)
	REALPATH=`find -maxdepth 3 -type d -name "${FNAME#\.\/}"`;
	#cp -v /var/lib/asterisk/freepbx-weblate/po/ja/${FNAME#\.\/}* $REALPATH/i18n/ja_JP/LC_MESSAGES/	
	cp -v $WORKDIR/po/ja/${FNAME#\.\/}* $REALPATH/i18n/$LANGCODE/LC_MESSAGES/
	# Now we need to handle amp.po
	#cp -v ~/freepbx-weblate/po/ja/amp.* /var/www/html/admin/i18n/ja_JP/LC_MESSAGES/
	# Now we need to handle ari.po
	#cp -v ~/freepbx-weblate/po/ja/ari.* /var/www/html/recordings/locale/ja_JP/LC_MESSAGES/ 
	popd;
done
pushd /var/www/html/;
# Now we need to handle amp.po
cp -v $WORKDIR/po/ja/amp.* /var/www/html/admin/i18n/$LANGCODE/LC_MESSAGES/
# Now we need to handle ari.po
cp -v $WORKDIR/po/ja/ari.* /var/www/html/recordings/locale/$LANGCODE/LC_MESSAGES/
popd
popd
#   Now all we have to do is copy the .po and .mo files together into the right place
#cp -v -r html/* /var/www/html/
#   At the end we delete all the .mo files since we shouldn't have them around in git
echo "Deleting .mo files…"
for oldmos in `find . -name "*.mo"`; do rm -f $oldmos; done
#   I think we are done now…
NOW=$(date)
echo "Local translation was updated and applied at " $NOW >> translationupdate.log #Remove this if you want later
echo "Done, now refresh the browser and check out your work. Don't forget to commit your changes."
