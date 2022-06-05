-- which ten countries have won the most table tennis golds?
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
where
	s.name = 'Table Tennis'
group by
	c.name
order by
	quantity desc
limit
	10;
