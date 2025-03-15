#!/usr/bin/bash

LOG_FILE="/var/log/db_monitor.log"
THRESHOLD=90
DB_USER="sys"
DB_PASSWORD="1234"
TEMP_FILE=$(mktemp /tmp/db_check.XXXXXX)

log_message() {
    local LEVEL=$1
    local MESSAGE=$2
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$LEVEL] $MESSAGE" >> $LOG_FILE
}

cleanup() {
    rm -f "$TEMP_FILE"
    log_message "INFO" "Temporary file cleaned up."
}

handle_error() {
    log_message "ERROR" "$1"
    cleanup
    exit 1
}

# Check disk usage
CURRENT_USAGE=$(df / | grep / | awk '{print $5}' | sed 's/%//')
if [ "$CURRENT_USAGE" -gt "$THRESHOLD" ]; then
    log_message "WARNING" "Disk space is above $THRESHOLD%. Current usage: $CURRENT_USAGE%"
else
    log_message "INFO" "Disk space is within acceptable limits."
fi

# Check for database anomalies
log_message "INFO" "Checking for database anomalies."

# Check dba_audit_trail for entries in the last 24 hours
sqlplus -s "$DB_USER/$DB_PASSWORD@//127.0.0.1/FREE as sysdba" <<EOF > "$TEMP_FILE"
    SET HEADING OFF
    SET FEEDBACK OFF
    SET PAGESIZE 0
    SET LINESIZE 1000
    SELECT * FROM dba_audit_trail WHERE timestamp > SYSDATE - 1;
    EXIT;
EOF

if [ ! -s "$TEMP_FILE" ] || grep -qi "no rows selected" "$TEMP_FILE"; then
    log_message "INFO" "No anomalies found in dba_audit_trail."
else
    log_message "ERROR" "Database anomalies detected in dba_audit_trail:"
    cat "$TEMP_FILE" >> $LOG_FILE
fi

# Check for invalid objects
sqlplus -s "$DB_USER/$DB_PASSWORD@//127.0.0.1/FREE as sysdba" <<EOF > "$TEMP_FILE"
    SET HEADING OFF
    SET FEEDBACK OFF
    SET PAGESIZE 0
    SET LINESIZE 1000
    SELECT object_name, object_type FROM dba_objects WHERE status = 'INVALID';
    EXIT;
EOF

if [ ! -s "$TEMP_FILE" ] || grep -qi "no rows selected" "$TEMP_FILE"; then
    log_message "INFO" "No invalid objects found in the database."
else
    log_message "ERROR" "Database invalid objects detected:"
    cat "$TEMP_FILE" >> $LOG_FILE
fi

# Cleanup
cleanup