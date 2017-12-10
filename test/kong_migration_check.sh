#!/bin/bash

CASSANDRA_HOST=$1

function print_schema_migrations() {
    echo "&&&&&&&&  $(date)"

    echo "Print kong.schema_migrations table"
    cqlsh ${CASSANDRA_HOST} -e "select * from kong.schema_migrations;"

    echo "Print count of entries in kong.schema_migrations table"
    cqlsh ${CASSANDRA_HOST} -e "select count(*) from kong.schema_migrations;"
}

function print_tables_count() {
    echo "&&&&&&&&  $(date)"

    for table in apis consumers plugins
    do
        echo "Print count of entries in kong.${table} table"
        cqlsh ${CASSANDRA_HOST} -e "select count(*) from kong.${table};"
    done
}


# Main
print_schema_migrations | tee -a $(dirname $0)/migrations.log
print_tables_count | tee -a $(dirname $0)/tables.log
