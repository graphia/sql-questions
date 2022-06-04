drop table if exists athlete;
drop type if exists sex;

create type sex as enum ('Male', 'Female');

create table athlete (
	id integer primary key,
	name varchar(128) not null,
	sex sex not null,
	height integer null,
	weight integer null
);

create index athlete_name on athlete(name);
