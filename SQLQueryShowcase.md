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
|       3.53 |

## Query 3: Count the total number of ratings in the dataset.
```sql
SELECT COUNT(ratingId) AS total_ratings
FROM ratings;
``` 

*Output:*
| total_ratings |
|:--------------|
|      25000095 |

   
## Query 4: Find the total number of users who have rated movies.
```sql
SELECT COUNT(DISTINCT userId) AS total_users_with_ratings 
FROM ratings;
``` 

*Output:*
| total_users_with_ratings |
|:-------------------------|
|     162541               |

## Query 5: List the top 5 movies with the highest average rating.
```sql
SELECT movieId, AVG(rating) AS avg_rating
FROM ratings
GROUP BY movieID
ORDER BY avg_rating DESC
LIMIT 5;
```

*Output:*
 movieid | avg_rating 
---------|------------
   86975 |          5
   83161 |          5
   31945 |          5
   27914 |          5
   92783 |          5

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
  72315 |       32202

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
   genre   | avg_rating 
-----------|------------
 Action    |       3.47
 Adventure |       3.52
 Animation |       3.61
 Children  |       3.43
 Comedy    |       3.42
 ...       |       ...

## Query 8: Find Movies with a High Average Rating
```sql
SELECT movieId, ROUND(AVG(rating)::numeric, 2) AS avg_rating
FROM ratings
GROUP BY movieId
HAVING AVG(rating) > 4.5;
``` 

*Output:*
 movieid | avg_rating 
---------|------------
   27914 |       5.00
   31945 |       5.00
   56548 |       4.67
   79866 |       4.75
   83161 |       5.00
   ...   |       ...

## Query 9: Find Movies with Diverse Ratings.
Diverse ratings are determined by assessing the variance of ratings for each movie. Variance, in this context, signifies the extent to which ratings deviate from their average value, indicating the dispersion or spread of opinions among viewers regarding the movie's quality. A higher variance suggests a wider range of ratings, reflecting diverse perspectives and differing opinions among viewers. This metric helps in identifying movies where viewers' assessments vary significantly, highlighting the diversity of opinions within the audience.

*First (inefficient) query:*
```sql
SELECT m.movieId, m.title, ROUND(VARIANCE(r.rating)::numeric, 2) AS var_rating
FROM ratings r
JOIN movies m ON m.movieId = r.movieId
GROUP BY m.movieId
HAVING COUNT(*) >= 10 AND VARIANCE(r.rating) > 1.5
ORDER BY var_rating DESC;
``` 

By filtering out movies with fewer than 10 ratings and a variance greater than 1.5 in a subquery before aggregating the ratings per movie, we can potentially reduce the amount of data processed and improve the overall performance of the query. 

*Optimized query:*
```sql
SELECT m.movieId, m.title, ROUND(r.var_rating::numeric, 2) AS var_rating
FROM (
    SELECT movieId, VARIANCE(rating) AS var_rating
    FROM ratings
    GROUP BY movieId
    HAVING COUNT(*) >= 10 AND VARIANCE(rating) > 1.5
) AS r
JOIN movies m ON m.movieId = r.movieId
ORDER BY r.var_rating DESC;
``` 

*Output:*
 movieid |                title                | var_rating 
---------|-------------------------------------|------------
   78064 | Ween Live in Chicago (2004)         |       4.29
  173945 | The Wearing of the Grin (1951)      |       3.82
  185669 | CM Punk: Best in the World (2012)   |       3.81
  153756 | Shok (2015)                         |       3.80
   49872 | Loose Change: Second Edition (2006) |       3.78
    ...  | ...                                 |       ...


## Query 10: Identify the most commonly applied tag for each movie.
*First (inefficient) query:*
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

To optimize this query for PostgreSQL, we can rewrite it to use window functions instead of subqueries in the HAVING clause. This can improve performance, especially when dealing with large datasets.

*Optimized query:*
```sql
SELECT movieId, title, most_common_tag, tag_count
FROM (
    SELECT 
        m.movieId, 
        m.title, 
        t.tag AS most_common_tag, 
        COUNT(*) AS tag_count,
        RANK() OVER (PARTITION BY m.movieId ORDER BY COUNT(*) DESC) AS tag_rank
    FROM movies m
    JOIN tags t ON m.movieId = t.movieId
    GROUP BY m.movieId, m.title, t.tag
) ranked_tags
WHERE tag_rank = 1
LIMIT 5;
```

*Output:*
 movieid |          title          | most_common_tag | tag_count 
---------|-------------------------|-----------------|-----------
       1 | Toy Story (1995)        | animation       |        72
       2 | Jumanji (1995)          | Robin Williams  |        34
       3 | Grumpier Old Men (1995) | Jack Lemmon     |         2
       3 | Grumpier Old Men (1995) | moldy           |         2
       3 | Grumpier Old Men (1995) | sequel          |         2
    ...  | ...                     | ...             |       ...

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
 movieid |                   title                   | uniq_tag_num 
---------|-------------------------------------------|--------------
     260 | Star Wars: Episode IV - A New Hope (1977) |          766
     356 | Forrest Gump (1994)                       |          550
     296 | Pulp Fiction (1994)                       |          517
     318 | Shawshank Redemption, The (1994)          |          405
    2571 | Matrix, The (1999)                        |          292
     ... | ...                                       |          ...

## Query 12: Find the users who have rated all movies in a specific genre.
```sql
SELECT r.userId
FROM ratings r
JOIN movies m ON r.movieId = m.movieId
WHERE m.genres LIKE '%Comedy%'
GROUP BY r.userId
HAVING COUNT(DISTINCT r.movieId) = (
    SELECT COUNT(*)
    FROM movies
    WHERE genres LIKE '%Comedy%'
);

```

*Output:*
|userid|
|------|

## Query 13: Identify users who have rated more movies in a particular genre than 10% of the total number of movies in that genre.

```sql
WITH genre_ratings AS (
    SELECT UNNEST(STRING_TO_ARRAY(genres, '|')) AS genre, COUNT(*) AS total_ratings
    FROM movies
    GROUP BY genre
)
SELECT r.userId, m.genre, COUNT(*) AS num_ratings
FROM ratings r
JOIN (
    SELECT movieId, UNNEST(STRING_TO_ARRAY(genres, '|')) AS genre
    FROM movies
) m ON r.movieId = m.movieId
JOIN genre_ratings gr ON m.genre = gr.genre
GROUP BY r.userId, m.genre, gr.total_ratings
HAVING COUNT(*) > gr.total_ratings * 0.1;
``` 


*Output:*
userid  | genre | num_ratings 
--------|-------|-------------
      3 | IMAX  |          81
      4 | IMAX  |          41
     13 | IMAX  |          40
     19 | IMAX  |          36
     75 | IMAX  |          25
     ...| ...   |         ...

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
        SQRT(SUM(u1.centered_rating * u1.centered_rating) * SUM(u2.centered_rating * u2.centered_rating)) AS norm_product
    FROM centered_ratings u1
    JOIN centered_ratings u2 ON u1.movieId = u2.movieId AND u1.userId < u2.userId
    GROUP BY u1.userId, u2.userId
)
SELECT
    user1,
    user2,
    CASE
        WHEN norm_product = 0 THEN 0
        ELSE dot_product / norm_product
    END AS similarity
FROM user_pairs;
``` 

*Example of output:*
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
        SQRT(SUM(u1.centered_rating * u1.centered_rating)) * SQRT(SUM(u2.centered_rating * u2.centered_rating)) AS norm_product
    FROM centered_ratings u1
    JOIN centered_ratings u2 ON u1.movieId = u2.movieId AND u1.userId < u2.userId
    GROUP BY u1.userId, u2.userId
)
SELECT 
    target_user,
    ARRAY_AGG(similar_user ORDER BY similarity DESC) AS similar_neighbors
FROM (
    SELECT
        user1 AS target_user,
        user2 AS similar_user,
        CASE
            WHEN norm_product = 0 THEN 0
            ELSE dot_product / norm_product
        END AS similarity,
        ROW_NUMBER() OVER (PARTITION BY user1 ORDER BY dot_product DESC) AS similarity_rank
    FROM user_pairs
) AS ranked_similarity
WHERE similarity_rank <= 10 AND similarity > 0.8
GROUP BY target_user;

``` 

*Example of output:*
target_user  |             similar_neighbors             
-------------|-------------------------------------------
           1 | {77,12,388,358,291,253,85,2,146,278}
           2 | {468,299,144,82,597,291,316,115,193,524}
           3 | {222,496,121,98,55,277,509,539,34,127}
           4 | {291,107,158,431,245,537,556,544,396,378}
           5 | {364,277,533,204,371,151,269,492,456,214}
         ... | ...