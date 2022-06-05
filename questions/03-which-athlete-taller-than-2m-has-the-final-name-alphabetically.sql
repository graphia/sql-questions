-- which athlete taller than 2m has the last name when sorted alphabetically?

select
	name
from
	athlete
where
	height >= 200
order by
	name desc
limit
	1;
