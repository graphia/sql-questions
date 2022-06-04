db=olympics

test:
	dropdb createdb build_inserts build_types_and_tables insert

insert:
	psql ${db} < ./dml/insert_data.sql

build_inserts:
	ruby ./build/extract.rb > ./dml/insert_data.sql

dropdb:
	dropdb --if-exists ${db}

createdb:
	createdb ${db}

build_types_and_tables:
	psql ${db} < ./ddl/country.sql
	psql ${db} < ./ddl/athlete.sql
	psql ${db} < ./ddl/games.sql
	psql ${db} < ./ddl/sport.sql
	psql ${db} < ./ddl/event.sql
	psql ${db} < ./ddl/appearance.sql

build_dump:
	cat ddl/{country,athlete,sport,games,event,appearance}.sql dml/insert_data.sql > olympics-database.sql
