#!/bin/bash
echo "Creating Chinook database to container"
# antes borro chinook si es que existe
psql -U "$POSTGRES_USER" -c "DROP DATABASE IF EXISTS chinook"
psql -U "$POSTGRES_USER" -c "CREATE DATABASE chinook"
psql -U "$POSTGRES_USER" -d chinook -a -f chinook/3_chinook_fisico_estructura.sql
psql -U "$POSTGRES_USER" -d chinook -a -f chinook/3_chinook_fisico_datos.sql
echo "Chinook database created successfully"

# ahora para dellstore2
echo "Creating Dellstore2 database to container"
# antes borro dellstore2 si es que existe
psql -U "$POSTGRES_USER" -c "DROP DATABASE IF EXISTS dellstore2"
psql -U "$POSTGRES_USER" -c "CREATE DATABASE dellstore2"
psql -U "$POSTGRES_USER" -d dellstore2 -a -f dellstore2/3_dellstore2_fisico_estructura.sql
psql -U "$POSTGRES_USER" -d dellstore2 -a -f dellstore2/3_dellstore2_fisico_datos.sql
echo "Dellstore2 database created successfully"

# ahora para northwind
echo "Creating Northwind database to container"
# antes borro northwind si es que existe
psql -U "$POSTGRES_USER" -c "DROP DATABASE IF EXISTS northwind"
psql -U "$POSTGRES_USER" -c "CREATE DATABASE northwind"
psql -U "$POSTGRES_USER" -d northwind -a -f northwind/3_northwind_fisico_estructura.sql
psql -U "$POSTGRES_USER" -d northwind -a -f northwind/3_northwind_fisico_datos.sql
echo "Northwind database created successfully"

# ahora para pagila 
echo "Creating Pagila database to container"
# antes borro pagila si es que existe
psql -U "$POSTGRES_USER" -c "DROP DATABASE IF EXISTS pagila"
psql -U "$POSTGRES_USER" -c "CREATE DATABASE pagila"
psql -U "$POSTGRES_USER" -d pagila -a -f pagila/3_pagila_fisico_estructura.sql
psql -U "$POSTGRES_USER" -d pagila -a -f pagila/3_pagila_fisico_datos.sql
echo "Pagila database created successfully"




