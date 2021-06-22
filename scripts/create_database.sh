#!/bin/bash

function create_user() {
  local user
  user=$1
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    DO
    \$do$
    BEGIN
      CREATE ROLE $user LOGIN PASSWORD '$user';
      EXCEPTION WHEN DUPLICATE_OBJECT THEN
      RAISE NOTICE 'not creating role my_role -- it already exists';
    END
    \$do$
EOSQL
  echo "$user created"
}

function create_database() {
  local database
  database=$1
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    SELECT 'CREATE DATABASE $database'
    WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '$database')\gexec
EOSQL
  echo "$database created"
}

function grantPrivilegesOnDB() {
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    GRANT ALL PRIVILEGES ON DATABASE $1 to $2;
    GRANT ALL PRIVILEGES ON DATABASE $1 to $POSTGRES_USER;
EOSQL
}

if [ -n "$POSTGRES_MULTIPLE_DATABASES" ]; then
  echo "Multiple database creation requested: $POSTGRES_MULTIPLE_DATABASES"
  for db in $(echo "$POSTGRES_MULTIPLE_DATABASES" | tr ',' ' '); do
    userName=$(echo "$db" | tr ':' ' ' | awk '{print $2}')
    dbName=$(echo "$db" | tr ':' ' ' | awk '{print $1}')
    create_user "$userName"
    create_database "$dbName"
    grantPrivilegesOnDB "$dbName" "$userName"
  done
  echo "Multiple databases created"
fi
