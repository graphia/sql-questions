-- which country won most biathlon medals between 1990 and 2010

select
	c.name,
	count(*) quantity
from
	appearance a
inner join
	event e
		on a.event_id = e.id
inner join
	sport s
		on e.sport_id = s.id
inner join
	country c
		on a.country_code = c.code
inner join
	games g
		on a.games_code = g.code
where
	s.name = 'Biathlon'
and
	a.medal is not null
and
	g.year between 1990 and 2010
group by
	c.name
order by
	quantity desc 
limit
	1
