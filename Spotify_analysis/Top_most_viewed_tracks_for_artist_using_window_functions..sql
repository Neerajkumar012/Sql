-- most view track for each artist using function

select *
from 
(	select 
		artist,
		track,
		sum(views) as views,
		dense_rank() over (partition by artist order by sum(views)desc) as top_rank
	from 
		spotify
	group by 
		artist,
		track
	order by 
		artist,
		views desc
	)
where 
	top_rank <4;
