-- which sports did France win medals at in the 1952 summer games?

select
	distinct(s.name)
from
	appearance a
inner join
	event e
		on a.event_id = e.id
inner join
	sport s
		on e.sport_id = s.id
inner join
	games g
		on a.games_code = g.code
where
	g.year = 1952
and
	g.season = 'Summer'
and
	a.country_code = 'FRA';
