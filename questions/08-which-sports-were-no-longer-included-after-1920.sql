-- which sports were played before 1920 but not after?

with sports_played_after_1920 as (
	select
		distinct(s.id)
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
		g.year >= 1920
)
select
	name
from
	sport
where
	id not in (select id from sports_played_after_1920);
