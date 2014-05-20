#!/bin/bash

# Variables
# Where to create the backups; It should already exist
BACKUP=backup
# Day of the week;
DAYOFWEEK=$(date +"%w")
# Folder for all daily backups
DAYBACKUP=$BACKUP/daily
# Name of directory to create for current backup  
TODAYBACKUP=$DAYBACKUP/$DAYOFWEEK
# directory to store last weeks data
ARCHIVE=$BACKUP/archive
# Location of a file to hold the date stamp of last level 0 backup
DATESTAMP=$BACKUP/.datestamp
NOW=$(date)
# Log dir
LOG=$BACKUP/logs
# Logfile
LOGFILE=$LOG/$(date +"%m%d%Y_%s").log

echo "Enter 1 to backup all filesystems or 2 to enter a specific filesystem followed by [ENTER]:"

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
    mkdir $BACKUP
	echo "Making $BACKUP directory"
else
	echo "Backing up to $BACKUP directory."
fi

# Does the daily backup directory exist? If it doesn't it will create it.
if [ ! -d "$DAYBACKUP" ]
then
	mkdir $DAYBACKUP
	echo "Making $DAYBACKUP directory"
else
	echo "$DAYBACKUP directory exists"
fi

# Does the log directory exist? If it doesn't it will create it.
if [ ! -d $LOG ]
then
	mkdir $LOG
	echo "Making $LOG directory"
else 
	echo "$LOG directory exists"
fi

echo "Piping to $LOGFILE"
exec 3>&1                         # create pipe (copy of stdout)
exec 1> "$LOGFILE"                   # direct stdout to file
exec 2>&1                         # uncomment if you want stderr too

echo "Start Time: $NOW" 1>&3
echo " "
echo "_____________________________________"
echo "$Linux Backup Script"
echo " "
echo "Start Time: $NOW"
echo "_____________________________________"
echo " "
echo " "

	echo "Incremental Backup" 1>&3
	#Incremental backup
	# Does todays backup dir exist? If it doesn't it will create it.
	if [ ! -d $TODAYBACKUP ]
		then
		mkdir $TODAYBACKUP
		echo "Making $TODAYBACKUP directory" 1>&3
	else
		echo "$TODAYBACKUP directory exists" 1>&3
	fi

	# Does the timestamp file exist? If it doesn't it will create it.
	if [ ! -w $DATESTAMP ]
	then
		touch $DATESTAMP
		echo "2014-04-16" > $DATESTAMP
		echo "Date stamp is $DATESTAMP" 1>&3
	else
		echo "Date stamp is $DATESTAMP" 1>&3
	fi

	for BACKUPFILES in $FILESYSTEMS
	do
		echo "FOR DO LOOP" 1>&3
		OUTFILENAME=$BACKUPFILES.tar
		OUTFILE=$TODAYBACKUP/$OUTFILENAME
		STARTTIME=`date`
		tar --create \
		--file $OUTFILE \
		--label "Backup ${NOW}" \
		$BACKUPFILES 
		echo "Outfile name is $OUTFILE" 1>&3
		gzip -verbose $OUTFILE
        #rm -f $OUTFILE
	done
	echo "done" 1>&3


SCRIPTFINISHTIME=`date`
echo " "
echo "_____________________________________"
echo "$Linux Backup Script"
echo " "
echo "Finish Time: $SCRIPTFINISHTIME"
echo "_____________________________________"
echo " "
echo " "

echo "Finish Time: $SCRIPTFINISHTIME" 1>&3
exit 1
