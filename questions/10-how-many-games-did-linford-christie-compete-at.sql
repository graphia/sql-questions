-- how many games did Linford Christie compete at?
-- what were his best results?
select
	name,
	games_code,
	max(medal) as best_finish
from
	appearance app
inner join
	athlete ath
		on app.athlete_id = ath.id
where
	ath.name like 'Linford%Christie'
group by
	name,
	games_code;
