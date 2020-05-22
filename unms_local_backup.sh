#!/bin/bash

################################################################
##
##   UNMS Local Backup Script
##   Version 1.0
##   Last Update: May 21, 2020
##
################################################################

export PATH=/bin:/usr/bin:/usr/local/bin
TODAY=$(date +%Y-%m-%d)
HOSTNAME=$(hostname -s)

################################################################
################## Update below values  ########################

PATH_UNMS_FOLDER_TO_BACKUP="/home/unms/data/"
PATH_OF_LOCAL_BACKUP_FOLDER="/root/UNMS_Manual_Backups/"
PATH_OF_FIRMWARE_FOLDER="/home/unms/data/firmwares"   ## Do not put / at end if folder. Will be excluded from tar file.
ARCHIVE_FILE_NAME="unms-data-$HOSTNAME-$TODAY.tar.bz2"
BACKUP_RETAIN_DAYS=30   ## Number of days to keep local backup copies

#################################################################

# GO TO LOCAL BACKUP FOLDER AND CREATE NEW FOLDER
cd ${PATH_OF_LOCAL_BACKUP_FOLDER}
mkdir -p ${TODAY}
cd ${PATH_OF_LOCAL_BACKUP_FOLDER}${TODAY}/
echo "Backup started for UNMS data to ${PATH_OF_LOCAL_BACKUP_FOLDER}${TODAY}/${ARCHIVE_FILE_NAME}"

# STOP UNMS
sudo /home/unms/app/unms-cli stop

# TAR THE DATA DIRECTORY
echo
echo "Packing data into the tar file named ${ARCHIVE_FILE_NAME} ..."
sudo tar --exclude=${PATH_OF_FIRMWARE_FOLDER} -cvjSf ${ARCHIVE_FILE_NAME} ${PATH_UNMS_FOLDER_TO_BACKUP}

# START UNMS
echo
echo "Restarting UNMS..."
sudo /home/unms/app/unms-cli start

echo
echo "Backup finished"

##### Remove backups older than {BACKUP_RETAIN_DAYS} days  #####

DBDELDATE=$(date -d "${BACKUP_RETAIN_DAYS} days ago" +%Y-%m-%d)

if [ ! -z ${PATH_OF_LOCAL_BACKUP_FOLDER} ]; then
      cd ${PATH_OF_LOCAL_BACKUP_FOLDER}
      if [ ! -z ${DBDELDATE} ] && [ -d ${DBDELDATE} ]; then
            rm -rf ${DBDELDATE}
      fi
fi

### End of script ####
