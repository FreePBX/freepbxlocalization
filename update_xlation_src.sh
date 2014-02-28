#!/bin/bash
#   This script compiles .po files as binary .mo files and copies them to the appropriate locations on the FreePBX distro.
#   I'm sorry, but you have to run it as root. Maybe Dave can think of a more elegant way to do this.
#   First, we will compile the .po files into .mo files.
#   This command includes the -f flag to include fuzzy strings
#   

#   Usage: ./update_xlation.sh <langcode> <dir_to_use>
#   Example: ./update_xlation.sh ja_JP /usr/src

# Define language code
LANGCODE=$1
# Define directory to use
USEDIR=$2
# Use the working directory as a variable later on so we know where to come back to
WORKDIR=`pwd`

# First we check for correct usage
[ $# -eq 0 ] && { echo "Usage: $0 language_code dir_to_use"; echo "Example language code: ja_JP for Japanese, fr_FR for French..."; exit 1;}

# Set default USEDIR to /var/www/html/ if no argument supplied
if [ -z "$2" ]
  then
    echo "No directory to use supplied! How about /usr/src/ ? Usage: $0 language_code dir_to_use";
    exit 1;
    #USEDIR=/var/www/html/;
    # I wanted to do this the way we discussed, but the source code and an actual install structure
    # are different in directory layers and such. I have just adjusted for source from git here, so you
    # can't use this on an active directory
fi

echo "Compiling .po files into .mo binaries for use…"
pushd po/$LANGCODE;
for pofile in `find . -name "*.po"`; do 
	# FNAME is "./<pofilenamehere>" without its .po extension
	FNAME=${pofile%.po}; 
	# Compile an mo binary using $FNAME.mo
	msgfmt -f -v $pofile -o ${FNAME}.mo; 
	#echo $fname "This is fname";
	# Go to the installation directory - we might need to change this
	# depending on how we work with these files
	pushd $USEDIR;

	# Find ./admin/modules/$FNAME (with no ./ in front)
	#REALPATH=`find -maxdepth 3 -type d -name "${FNAME#\.\/}"`;

	#  ^^ This doesn't work in our case with git so I changed
	REALPATH=`find -maxdepth 1 -type d -name "${FNAME#\.\/}"`;

# If the po file is here but the directory (module) isn't included in the git source,
# then $REALPATH will be blank. We will test if it is blank and send a message letting
# us know that this particular po file has been "left behind"...
if [ -z "$REALPATH" ]
then
	echo ${FNAME#\.\/}" doesn't have a matching directory. Doing nothing!"
	popd
else
	#cp -v /var/lib/asterisk/freepbx-weblate/po/ja/${FNAME#\.\/}* $REALPATH/i18n/ja_JP/LC_MESSAGES/

	# Added test to create directories if needed based on language code
	if [ ! -d "$REALPATH/i18n/$LANGCODE/LC_MESSAGES" ]; then
	  # Control will enter here if it doesn't exist.
	  echo "Creating new directory" $REALPATH"/i18n/"$LANGCODE"/LC_MESSAGES ..."
	  mkdir -p $REALPATH/i18n/$LANGCODE/LC_MESSAGES;
	fi	

	cp -v $WORKDIR/po/$LANGCODE/${FNAME#\.\/}.* $REALPATH/i18n/$LANGCODE/LC_MESSAGES/
	# Now we need to handle amp.po
	#cp -v ~/freepbx-weblate/po/ja/amp.* /var/www/html/admin/i18n/ja_JP/LC_MESSAGES/
	# Now we need to handle ari.po
	#cp -v ~/freepbx-weblate/po/ja/ari.* /var/www/html/recordings/locale/ja_JP/LC_MESSAGES/ 
	popd;

fi
done
pushd $USEDIR;
# Now we need to handle amp.po
#cp -v $WORKDIR/po/$LANGCODE/amp.* /var/www/html/admin/i18n/$LANGCODE/LC_MESSAGES/

# Now we need to handle amp.po in the right way for source code structure

	# Added test to create amp's localization dir if needed based on language code
	if [ ! -d "$USEDIR/framework/amp_conf/htdocs/admin/i18n/$LANGCODE/LC_MESSAGES" ]; then
	  # Control will enter here if it doesn't exist.
	  echo "Creating new directory" $USEDIR"/framework/amp_conf/htdocs/admin/i18n/"$LANGCODE"/LC_MESSAGES ..."
	  mkdir -p $USEDIR/framework/amp_conf/htdocs/admin/i18n/$LANGCODE/LC_MESSAGES;
	fi	

cp -v $WORKDIR/po/$LANGCODE/amp.* $USEDIR/framework/amp_conf/htdocs/admin/i18n/$LANGCODE/LC_MESSAGES/

# Now we need to handle ari.po
#cp -v $WORKDIR/po/$LANGCODE/ari.* /var/www/html/recordings/locale/$LANGCODE/LC_MESSAGES/

# Now we need to handle ari.po in the right way for source code structure

	# Added test to create amp's localization dir if needed based on language code
	if [ ! -d "$USEDIR/fw_ari/htdocs_ari/locale/$LANGCODE/LC_MESSAGES" ]; then
	  # Control will enter here if it doesn't exist.
	  echo "Creating new directory" $USEDIR"/fw_ari/htdocs_ari/locale/"$LANGCODE"/LC_MESSAGES ..."
	  mkdir -p $USEDIR/fw_ari/htdocs_ari/locale/$LANGCODE/LC_MESSAGES;
	fi	

cp -v $WORKDIR/po/$LANGCODE/amp.* $USEDIR/fw_ari/htdocs_ari/locale/$LANGCODE/LC_MESSAGES/

#cp -v $WORKDIR/po/$LANGCODE/ari.* /var/www/html/recordings/locale/$LANGCODE/LC_MESSAGES/

popd
popd
#   Now all we have to do is copy the .po and .mo files together into the right place
#cp -v -r html/* /var/www/html/
#   At the end we delete all the .mo files since we shouldn't have them around in git
echo "Deleting .mo files…"
for oldmos in `find . -name "*.mo"`; do rm -f $oldmos; done
#   I think we are done now…
NOW=$(date)
#echo "Local translation was updated and applied at " $NOW >> translationupdate.log #Remove this if you want later
echo "Done, now refresh the browser and check out your work. Don't forget to commit your changes."
