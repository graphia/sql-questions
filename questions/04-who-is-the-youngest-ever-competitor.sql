-- who is the youngest ever competitor?

select
	ath.name,
	c.name as country
from
	appearance ap
inner join
	athlete ath
		on ap.athlete_id = ath.id
inner join
	country c
		on ap.country_code = c.code
order by
	age asc
limit
	1;
