-- Use a WITH clause to calculate the difference between the highest and lowest energy values for
-- tracks in each album.

with diff_rgy as(select
	album,
	min(energy) as lowest,
	max(energy) as highest
from 
	spotify
group by 
	album
)
select 
	track,
	album,
	energy,
	lowest,
	highest,
	cast(highest-lowest as decimal(4,2)) as diff
	
from
	spotify
inner join 
	diff_rgy using(album)
order by 
	album asc,
	energy desc









