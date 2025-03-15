#!/usr/bin/bash

export ORACLE_SID=FREE
export ORACLE_BASE=/opt/oracle
export ORACLE_HOME=/opt/oracle/product/23ai/dbhomeFree
export PATH=/usr/sbin:$PATH
export PATH=$ORACLE_HOME/bin:$PATH

USER_PW="c##master/master"
BACKUP_PATH=/opt/oracle/oradata/exports

mkdir -p $BACKUP_PATH

BACKUP_FILE=backup_`date +%d-%m-%y`.dmp
LOG_FILE=backup_`date +%d-%m-%y`.log

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup Starting ..." >> $BACKUP_PATH/$LOG_FILE

expdp  $USER_PW full=y directory=dump_dir dumpfile=$BACKUP_FILE logfile=LOG_FILE.log

if [ $? -eq 0 ]; then
    cat /opt/oracle/oradata/exports/LOG_FILE.log >> $BACKUP_PATH/$LOG_FILE
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup completed successfully. File: $BACKUP_PATH/$BACKUP_FILE" >> $BACKUP_PATH/$LOG_FILE
    rm -f /opt/oracle/oradata/exports/LOG_FILE.log
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Error: Backup failed." >> $BACKUP_PATH/$LOG_FILE
fi
