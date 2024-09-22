-- Find tracks where the energy-to-liveness ratio is greater than 1.2.
with rgy_lvns as(select
	track,
	energy
	,liveness
	,cast(energy/liveness as decimal(4,2)) as ratio
from spotify
)
select 
	track
	,album
	,ratio
from 
	spotify
join rgy_lvns using(track)
where
	ratio>spotify.energy/spotify.liveness