-- how many gymnastic events are there?

select
	count(*)
from sport s
	inner join event e
		on s.id = e.sport_id
where
	s.name = 'Gymnastics';
