-- Calculate the average danceability of tracks in each album.

select 
	album,
	avg(danceability) as danceable
from
	spotify
group by 
	album
order by 
	danceable desc
limit 8;