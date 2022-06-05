-- which five events have the longest names?

select
	name,
	length(name) size
from
	event
order by
	size desc
limit
	5;
