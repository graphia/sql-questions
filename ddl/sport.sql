drop table if exists sport;

create table sport (
	id integer primary key,
	name varchar(32) not null
);

create index sport_name on sport(name);
