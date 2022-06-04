drop table if exists games;

create type season as enum ('Summer', 'Winter');

create table games (
	code char(6) primary key,
	name varchar(32) not null,
	year integer not null,
	season season not null,
	city varchar(32) not null
);

create index games_name on games(name);
create index games_city on games(city);
create index games_year on games(year);
