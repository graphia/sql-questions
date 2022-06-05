-- how many athletes have competed at both summer and winter games

with
	seasonal_appearances as (
		select
			a.athlete_id,
			g.season
		from
			appearance a
		inner join
			games g
				on a.games_code = g.code
		group by
			a.athlete_id,
			g.season
	),
	athletes_who_have_appeared_in_more_than_one_season as (
		select
			athlete_id
		from
			seasonal_appearances
		group by
			athlete_id
		having
			count(athlete_id) > 1
	)
select
	count(*)
from
	athletes_who_have_appeared_in_more_than_one_season;
