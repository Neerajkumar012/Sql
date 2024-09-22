-- Retrieve the track names that have been streamed on Spotify more than YouTube

select 
	track,
	spotify_streamed_views
from
	(
	select
		track,
		coalesce(sum(case when most_played_on='Youtube' then stream end),0)as youtube_streamed_views,
		coalesce(sum(case when most_played_on='Spotify' then stream end),0)as spotify_streamed_views
	from 
		spotify
	group by track
	)
where 
	youtube_streamed_views<spotify_streamed_views 
	and
	youtube_streamed_views<>0
order by 
	2 desc;
	