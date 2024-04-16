/*
Assume there are three Spotify tables: artists, songs, and global_song_rank,
which contain information about the artists, songs, and music charts, respectively.

Write a query to find the top 5 artists whose songs appear 
most frequently in the Top 10 of the global_song_rank table.
Display the top 5 artist names in ascending order, along with their song appearance ranking.

If two or more artists have the same number of song appearances, 
they should be assigned the same ranking, and the rank numbers should be continuous (i.e. 1, 2, 2, 3, 4, 5). 

artists Table:
Column Name	Type
artist_id	integer
artist_name	varchar
label_owner	varchar

artists Example Input:
artist_id	artist_name	label_owner
101	Ed Sheeran	Warner Music Group
120	Drake	Warner Music Group
125	Bad Bunny	Rimas Entertainment

songs Table:
Column Name	Type
song_id	integer
artist_id	integer
name	varchar

songs Example Input:
song_id	artist_id	name
55511	101	Perfect
45202	101	Shape of You
22222	120	One Dance
19960	120	Hotline Bling

global_song_rank Table:
Column Name	Type
day	integer (1-52)
song_id	integer
rank	integer (1-1,000,000)

global_song_rank Example Input:
day	song_id	rank
1	45202	5
3	45202	2
1	19960	3
9	19960	15

Example Output:
artist_name	artist_rank
Ed Sheeran	1
Drake	2
*/




SOLUTION USING SUBQUERY : 

SELECT *
FROM
(
select artist_name, 
dense_rank() OVER( ORDER BY count(s.song_id) DESC ) as artist_rank 
FROM artists a
JOIN songs s ON a.artist_id = s.artist_id
JOIN global_song_rank g ON s.song_id = g.song_id 
where g.rank <= 10
group by a.artist_name
) a
where artist_rank <= 5;


SOLUTION USING CTE :

WITH top_10_cte AS (
  SELECT 
    artists.artist_name,
    DENSE_RANK() OVER (
      ORDER BY COUNT(songs.song_id) DESC) AS artist_rank
  FROM artists
  INNER JOIN songs
    ON artists.artist_id = songs.artist_id
  INNER JOIN global_song_rank AS ranking
    ON songs.song_id = ranking.song_id
  WHERE ranking.rank <= 10
  GROUP BY artists.artist_name
)

SELECT artist_name, artist_rank
FROM top_10_cte
WHERE artist_rank <= 5;
