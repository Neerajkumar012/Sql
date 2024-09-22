--  highest energy values
select 
	track,
	avg(energy) as energy
from 
	spotify
group by
	track
order by 
	energy  desc
limit 10;