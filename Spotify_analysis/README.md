# Spotify Advanced SQL Project and Query Optimization P-6
Project Category: Advanced
[Click Here to get Dataset](https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset)

## Overview
This project involves analyzing a Spotify dataset with various attributes about tracks, albums, and artists using **SQL**. It covers an end-to-end process of normalizing a denormalized dataset, performing SQL queries of varying complexity (easy, medium, and advanced), and optimizing query performance. The primary goals of the project are to practice advanced SQL skills and generate valuable insights from the dataset.

```sql
-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);
```
## Analysis

### Medium Level
1. Calculate the average danceability of tracks in each album.
```sql
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
```
2. Find the top 5 tracks with the highest energy values.
```sql
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
```
3. List all tracks along with their views and likes where `official_video = TRUE
```sql
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
```
4. Retrieve the track names that have been streamed on Spotify more than YouTube.
```sql
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
	
```

### Advanced Level
1. Find the top 3 most-viewed tracks for each artist using window functions.
```sql
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
	top_rank <4

-- select * from spotify limit 5;
```
2. Write a query to find tracks where the liveness score is above the average.
```sql
-- Records for above average liveness
select 
	* 
from 
	spotify 
where 
	liveness>(select avg(liveness) from spotify);
```
3. **Use a `WITH` clause to calculate the difference between the highest and lowest energy values for tracks in each album.**
```sql
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
	energy desc;
```
   
4. Find tracks where the energy-to-liveness ratio is greater than 1.2.
```sql
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
	ratio>spotify.energy/spotify.liveness;
```


---

## Query Optimization Technique 

To improve query performance, we carried out the following optimization process:

- **Initial Query Performance Analysis Using `EXPLAIN`**
    - We began by analyzing the performance of a query using the `EXPLAIN` function.
    - The query retrieved tracks based on the `artist` column, and the performance metrics were as follows:
        - Execution time (E.T.): **4.994 ms**
        - Planning time (P.T.): **0.120 ms**
    - Below is the **screenshot** of the `EXPLAIN` result before optimization:
      ![EXPLAIN Before Index](https://github.com/Neerajkumar012/Sql/edit/main/Spotify_analysis/Before_index.png)

- **Index Creation on the `artist` Column**
    - To optimize the query performance, we created an index on the `artist` column. This ensures faster retrieval of rows where the artist is queried.
    - **SQL command** for creating the index:
      ```sql
      CREATE INDEX idx_artist ON spotify_tracks(artist);
      ```

- **Performance Analysis After Index Creation**
    - After creating the index, we ran the same query again and observed significant improvements in performance:
        - Execution time (E.T.): **1.426 ms**
        - Planning time (P.T.): **1.522 ms**
    - Below is the **screenshot** of the `EXPLAIN` result after index creation:
      ![EXPLAIN After Index](https://github.com/Neerajkumar012/Sql/edit/main/Spotify_analysis/After_index.png)

- **Graphical Performance Comparison**
    - A graph illustrating the comparison between the initial query execution time and the optimized query execution time after index creation.
    - **Graph view** shows the significant drop in both execution and planning times:
      ![Performance Graph](https://github.com/najirh/najirh-Spotify-Data-Analysis-using-SQL/blob/main/spotify_graphical%20view%203.png)
      ![Performance Graph](https://github.com/najirh/najirh-Spotify-Data-Analysis-using-SQL/blob/main/spotify_graphical%20view%202.png)
      ![Performance Graph](https://github.com/najirh/najirh-Spotify-Data-Analysis-using-SQL/blob/main/spotify_graphical%20view%201.png)

This optimization shows how indexing can drastically reduce query time, improving the overall performance of our database operations in the Spotify project.
---

## Technology Stack
- **Database**: PostgreSQL
- **SQL Queries**: DDL, DML, Aggregations, Joins, Subqueries, Window Functions
- **Tools**: pgAdmin 4 (or any SQL editor), PostgreSQL (via Homebrew, Docker, or direct installation)


