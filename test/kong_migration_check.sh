#!/bin/bash

PG_HOST=$1
PG_CMD=/usr/local/bin/psql.sh

function print_schema_migrations() {
    echo "&&&&&&&&  $(date)"

    echo "Print kong.schema_migrations table"
    echo "select * from schema_migrations;" | sudo ${PG_CMD}

    echo "Print count of entries in kong.schema_migrations table"
    echo "select count(*) from schema_migrations;" | sudo ${PG_CMD}
}

function print_tables_count() {
    echo "&&&&&&&&  $(date)"

    for table in apis consumers plugins
    do
        echo "Print count of entries in kong.${table} table"
        echo "select count(*) from ${table};" | sudo ${PG_CMD}
    done
}


# Main
print_schema_migrations | tee -a $(dirname $0)/migrations.log
print_tables_count | tee -a $(dirname $0)/tables.log
