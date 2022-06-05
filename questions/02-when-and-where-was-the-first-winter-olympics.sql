-- when and where were the first Winter Olympic Games held?

select
	year,
	city
from
	games
where
	season = 'Winter'
order by
	year asc
limit
	1
;
