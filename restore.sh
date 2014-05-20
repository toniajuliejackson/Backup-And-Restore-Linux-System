#!/bin/bash

# Variables
# Where to create the backups; It should already exist
BACKUP=backup/daily


echo "Enter 1 to restore all filesystems or 2 to enter a specific filesystem followed by [ENTER]:"

read number
if [ $number -lt 1 ]
then
	echo "$0 error: you must supply an argument"
	exit 1
else
	if [ "$number" = "1" ]
	then
		echo "Backing up all filesystems"
  		FILESYSTEMS="/home"
	else
		echo "Enter the filesystem you would like to backup eg. /home followed by [ENTER]:"
		read file
		FILESYSTEMS="/$file"
		echo "The filesystem you chose to backup is $file"
		if [[ "$file" == "" ]]
		then
			echo "Error: you must supply an argument"
			exit 1
		fi
	fi
fi

# _____________________________________________________________________________________

# Is there a backup directory?
if [ ! -d "$BACKUP" ]
then
    echo "The specified backup directory $BACKUP does not exist."
	
else
	echo "Backing up to $BACKUP directory."
fi

# Get latest day of backup
LATESTDIR=$(ls -t $BACKUP | head -1)
RESTORE=$BACKUP/$LATESTDIR
if [ ! -d "$RESTORE" ]
then 
	echo "The specified restore files does not exist."
else
	echo "Restoring from $RESTORE directory."
fi

echo "$FILESYSTEMS:"

echo "tar xvzf $RESTORE/$FILESYSTEMS"
FULLDIR=$RESTORE/$FILESYSTEMS.tar
tar xvf $FULLDIR

echo "Done"
