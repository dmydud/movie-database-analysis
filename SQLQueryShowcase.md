# SQL Query Showcase: From Easy to Complex

In this document, I present a series of SQL queries arranged from easy to complex, demonstrating proficiency in data manipulation tasks.

## Query 1: Retrieve the title and genres of all movies.
```sql
SELECT title, genres 
FROM movies;
```

*Output:*
|              title                |                    genres                    
:-----------------------------------|:-----------------------------------------------
 Toy Story (1995)                   | Adventure\|Animation\|Children\|Comedy\|Fantasy
 Jumanji (1995)                     | Adventure\|Children\|Fantasy
 Grumpier Old Men (1995)            | Comedy\|Romance
 Waiting to Exhale (1995)           | Comedy\|Drama\|Romance
 Father of the Bride Part II (1995) | Comedy
 ...                                | ...

## Query 2: Find the average rating of all movies.
```sql
SELECT ROUND(AVG(rating)::numeric, 2) AS avg_rating 
FROM ratings;
``` 

*Output:*
| avg_rating |
|:-----------|
|       3.50 |

## Query 3: Count the total number of ratings in the dataset.
```sql
SELECT COUNT(ratingId) AS total_ratings
FROM ratings;
``` 

*Output:*
| total_ratings |
|:--------------|
|        100836 |
   
## Query 4: Find the total number of users who have rated movies.
```sql
SELECT COUNT(DISTINCT userId) AS total_users_with_ratings 
FROM ratings;
``` 

*Output:*
| total_users_with_ratings |
|:-------------------------|
|     610                  |

## Query 5: List the top 10 movies with the highest average rating.
```sql
SELECT movieId, AVG(rating) AS avg_rating
FROM ratings
GROUP BY movieID
ORDER BY avg_rating DESC
LIMIT 10;
```

*Output:*
 movieid | avg_rating 
:--------|:-----------
    6086 |          5
  138966 |          5
   74226 |          5
  136353 |          5
    5468 |          5
    ...  |        ...

## Query 6: Find the user who has rated the most number of movies.
```sql
SELECT userId, COUNT(ratingId) as num_ratings
FROM ratings 
GROUP BY userId 
ORDER BY num_ratings DESC 
LIMIT 1;
``` 

*Output:*
 userid | num_ratings 
--------|-------------
    414 |        2698

## Query 7: Calculate the average rating for each genre.
```sql
SELECT genre, ROUND(AVG(r.rating)::numeric, 2) AS avg_rating
FROM (
	SELECT movieId, UNNEST(STRING_TO_ARRAY(genres, '|')) AS genre 
	FROM movies
) AS movie_genres JOIN ratings r ON movie_genres.movieId = r.movieId
GROUP BY genre;
``` 

*Output:*
genre               | avg_rating 
--------------------|------------
 Action             |       3.45
 Adventure          |       3.51
 Animation          |       3.63
 Children           |       3.41
 Comedy             |       3.38
 ...                |       ...

## Query 8: Find Movies with a High Average Rating
```sql
SELECT movieId, ROUND(AVG(rating)::numeric, 2) AS avg_rating
FROM ratings
GROUP BY movieId
HAVING AVG(rating) > 4.5;
``` 

*Output:*
movieid  | avg_rating 
---------|------------
  138966 |       5.00
    5468 |       5.00
   42556 |       5.00
  118894 |       5.00
    4116 |       5.00
   ...   |       ...

## Query 9: Find Movies with Diverse Ratings.
Diverse ratings are determined by assessing the variance of ratings for each movie. Variance, in this context, signifies the extent to which ratings deviate from their average value, indicating the dispersion or spread of opinions among viewers regarding the movie's quality. A higher variance suggests a wider range of ratings, reflecting diverse perspectives and differing opinions among viewers. This metric helps in identifying movies where viewers' assessments vary significantly, highlighting the diversity of opinions within the audience.

```sql
SELECT m.movieId, m.title, ROUND(VARIANCE(r.rating)::numeric, 2) AS var_rating
FROM ratings r
JOIN movies m ON m.movieId = r.movieId
GROUP BY m.movieId
HAVING VARIANCE(r.rating) > 1.5
ORDER BY var_rating DESC;
``` 

*Output:*
 movieid |  title                                                             | var_rating 
---------|--------------------------------------------------------------------|------------
    2068 | Fanny and Alexander (Fanny och Alexander) (1982)                   |      10.13
   32892 | Ivan's Childhood (a.k.a. My Name is Ivan) (Ivanovo detstvo) (1962) |      10.13
   84847 | Emma (2009)                                                        |       8.00
     484 | Lassie (1994)                                                      |       8.00
    3223 | Zed & Two Noughts, A (1985)                                        |       8.00
    ...  | ...                                                                |       ...


## Query 10: Identify the most commonly applied tag for each movie.
```sql
SELECT m.movieId, m.title, t.tag AS most_common_tag, COUNT(*) AS tag_count
FROM movies m
JOIN tags t ON m.movieId = t.movieId
GROUP BY m.movieId, m.title, t.tag
HAVING COUNT(*) = (
    SELECT COUNT(*) AS max_tag_count
    FROM tags
    WHERE movieId = m.movieId
    GROUP BY movieId
    ORDER BY max_tag_count DESC
    LIMIT 1
);
```

*Output:*
movieid  |  title                                               | most_common_tag | tag_count 
---------|------------------------------------------------------|-----------------|-----------
       7 | Sabrina (1995)                                       | remake          |         1
      16 | Casino (1995)                                        | Mafia           |         1
      17 | Sense and Sensibility (1995)                         | Jane Austen     |         1
      21 | Get Shorty (1995)                                    | Hollywood       |         1
      22 | Copycat (1995)                                       | serial killer   |         1
    ...  | ...                                                  | ...             |       ...

## Query 11: Determine the movies that have the highest number of distinct tags.
```sql
SELECT m.movieId, m.title, COUNT(DISTINCT t.tag) AS uniq_tag_num
FROM movies m 
JOIN tags t ON m.movieId = t.movieId
GROUP BY m.movieId
ORDER BY uniq_tag_num DESC
LIMIT 10;
```

*Output:*
 movieid |                             title                              | uniq_tag_num 
---------|----------------------------------------------------------------|--------------
     296 | Pulp Fiction (1994)                                            |          173
    2959 | Fight Club (1999)                                              |           48
     924 | 2001: A Space Odyssey (1968)                                   |           40
     293 | Léon: The Professional (a.k.a. The Professional) (Léon) (1994) |           32
    1732 | Big Lebowski, The (1998)                                       |           32
     ... | ...                                                            |          ...

## Query 12: Find the users who have rated all movies in a specific genre.
```sql
SELECT r.userId
FROM ratings r
JOIN movies m ON r.movieId = m.movieId
WHERE m.genres LIKE '%Comedy%'
GROUP BY r.userId
HAVING COUNT(DISTINCT r.movieId) = (SELECT COUNT(*) FROM movies WHERE genres LIKE '%Comedy%');
```

*Output:*
|userid|
|------|

## Query 13: Identify users who have rated more movies in a particular genre than 10% of the total number of movies in that genre.
```sql
SELECT userId, genre, COUNT(*) AS num_ratings
FROM ratings r
JOIN (
	SELECT movieId, UNNEST(STRING_TO_ARRAY(genres, '|')) AS genre
	FROM movies
) m ON r.movieId = m.movieId
GROUP BY userId, genre
HAVING COUNT(*) > (
	SELECT COUNT(*)
	FROM movies
	WHERE m.genre = genre
) * .1;
``` 

*Output:*
userid  | genre  | num_ratings 
--------|--------|-------------
    414 | Comedy |        1079
    414 | Drama  |        1309
    474 | Drama  |        1173
    599 | Comedy |         975
    599 | Drama  |        1010

## Query 14: Calculate the similarity (Pearsons) between users based on their rating patterns.

This SQL query calculates the Pearson similarity between users based on their rating patterns. 

Pearson similarity formula:
$$r_{xy}={\frac {\sum _{i=1}^{n}(x_{i}-{\bar {x}})(y_{i}-{\bar {y}})}{{\sqrt {\sum _{i=1}^{n}(x_{i}-{\bar {x}})^{2}}}{\sqrt {\sum _{i=1}^{n}(y_{i}-{\bar {y}})^{2}}}}}$$

The Pearson similarity metric measures the correlation between two users' rating patterns, taking into account differences in rating scales and biases. A higher Pearson similarity value indicates a stronger similarity between users' rating patterns, suggesting that they have similar preferences in movies.

```sql
WITH centered_ratings AS (
    SELECT
        userId,
        movieId,
        rating - AVG(rating) OVER (PARTITION BY userId) AS centered_rating
    FROM ratings
),
user_pairs AS (
    SELECT
        u1.userId AS user1,
        u2.userId AS user2,
        SUM(u1.centered_rating * u2.centered_rating) AS dot_product,
        SQRT(SUM(u1.centered_rating * u1.centered_rating)) AS norm_user1,
        SQRT(SUM(u2.centered_rating * u2.centered_rating)) AS norm_user2
    FROM centered_ratings u1
    JOIN centered_ratings u2 ON u1.movieId = u2.movieId AND u1.userId < u2.userId
    GROUP BY u1.userId, u2.userId
)
SELECT
    user1,
    user2,
	CASE
		WHEN norm_user1 = 0 OR norm_user2 = 0 THEN 0
		ELSE dot_product / (norm_user1 * norm_user2)
    END AS similarity
FROM user_pairs;
``` 

*Output:*
user1  | user2 |       similarity        
-------|-------|-------------------------
   312 |   608 |     0.05077633337769104
   359 |   600 |     0.35148989887489773
    34 |   570 |     0.26308947779043923
   411 |   525 |      0.4048766565868244
   484 |   559 |     0.03341902211119086
   ... |   ... |     ...

## Query 15: Implement a recommendation system to suggest movies to users based on their rating history.

Based on user similarities (Query 14), the system generates recommendations for each user by identifying movies that similar users have rated highly. Users with similar rating patterns are more likely to enjoy similar movies, making this approach effective in personalized recommendation generation.

```sql
WITH similar_users AS (
    WITH centered_ratings AS (
        SELECT
            userId,
            movieId,
            rating - AVG(rating) OVER (PARTITION BY userId) AS centered_rating
        FROM ratings
    ),
    user_pairs AS (
        SELECT
            u1.userId AS user1,
            u2.userId AS user2,
            SUM(u1.centered_rating * u2.centered_rating) AS dot_product,
            SQRT(SUM(u1.centered_rating * u1.centered_rating)) AS norm_user1,
            SQRT(SUM(u2.centered_rating * u2.centered_rating)) AS norm_user2
        FROM centered_ratings u1
        JOIN centered_ratings u2 ON u1.movieId = u2.movieId AND u1.userId < u2.userId
        GROUP BY u1.userId, u2.userId
    )
    SELECT 
        target_user,
        similar_user,
        similarity,
        ROW_NUMBER() OVER (PARTITION BY target_user ORDER BY similarity DESC) AS similarity_rank
    FROM (
        SELECT
            user1 AS target_user,
            user2 AS similar_user,
            CASE
                WHEN norm_user1 = 0 OR norm_user2 = 0 THEN 0
                ELSE dot_product / (norm_user1 * norm_user2)
            END AS similarity
        FROM user_pairs
    )
)
SELECT 
    target_user,
    ARRAY_AGG(similar_user ORDER BY similarity_rank ASC) AS similar_neighbors
FROM similar_users
WHERE similarity_rank <= 10 AND similarity > .8
GROUP BY target_user;
``` 

*Output:*
target_user  |             similar_neighbors             
-------------|-------------------------------------------
           1 | {77,12,388,358,291,253,85,2,146,278}
           2 | {468,299,144,82,597,291,316,115,193,524}
           3 | {222,496,121,98,55,277,509,539,34,127}
           4 | {291,107,158,431,245,537,556,544,396,378}
           5 | {364,277,533,204,371,151,269,492,456,214}
         ... | ...