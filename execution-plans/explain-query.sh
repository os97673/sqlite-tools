#!/bin/sh
set -e
# source: https://developer.android.com/reference/android/database/sqlite/package-summary
# and manually added recent versions 3.39.2 (api 34)
SQLITE_VERSIONS="3.8.0 3.9.0 3.18.0 3.19.0 3.22.0 3.28.0 3.32.0 3.39.2 3.43.2"
BINARIES=$1
DB=$2
QUERY="${@:3}"
#"select 1,2,3 from message_ephemeral ephemeral JOIN available_message_view messages ON ephemeral.message_row_id=messages._id WHERE ephemeral.keep_in_chat!=1 AND ephemeral.expire_timestamp < 22222 LIMIT 100"
EXPLAIN_QUERY="explain query plan $QUERY;"

echo Running...
echo $EXPLAIN_QUERY
echo
for SQLITE_VERSION in $SQLITE_VERSIONS; do
    BINARY_DIR=$BINARIES/$SQLITE_VERSION/bin
    $BINARY_DIR/sqlite3 --version
    $BINARY_DIR/sqlite3 $DB "$EXPLAIN_QUERY"
    echo
done
