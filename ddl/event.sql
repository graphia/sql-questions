drop table if exists event;

create table event (
	id integer primary key,
	sport_id integer not null references sport(id),
	name varchar(128) not null
);

create index event_name on event(name);
create index event_sport_id on event(sport_id);
