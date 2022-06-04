drop table if exists country;

create table country (
	code char(3) primary key,
	name varchar(32) null,
	alternative_name varchar(32) null
);

create index country_name on country(name);
