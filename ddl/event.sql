drop table if exists event;

create table event (
	id integer primary key,
	sport_id integer not null references sport(id),
	name varchar(128) not null,

	sex sex generated always as (
		case
			when name like '%Women%' then 'Female'::sex
			when name like '%Men%' then 'Male'::sex
			else null
		end
		) stored
);

create index event_name on event(name);
create index event_sport_id on event(sport_id);
