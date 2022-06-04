drop table if exists appearance;

create type medal as enum ('Gold', 'Silver', 'Bronze');

create table appearance (
	athlete_id integer not null references athlete(id),
	country_code char(3) not null references country(code),
	games_code char(6) not null references games(code),
	event_id integer not null references event(id),
	age integer null,
	medal medal null
);

create unique index appearance_athlete_games_event on appearance(athlete_id, games_code, event_id, medal);
create index appearance_games_athlete on appearance(games_code, athlete_id);
