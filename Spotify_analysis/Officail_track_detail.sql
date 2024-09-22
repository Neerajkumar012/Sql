-- official track with total -views ,likes ,comment
select 
	track,
	sum(views) total_views,
	sum(likes) total_likes,
	sum(comments)total_comments
from 
	spotify
where 
	official_video is true
group by 
	track
order by 
	total_views desc
limit 40;