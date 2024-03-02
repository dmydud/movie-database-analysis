-- Import movies table
COPY movies (movieId, title, genres) FROM '/data/movies.csv' DELIMITER ',' CSV HEADER;

-- Import links table
COPY links (movieId, imdbId, tmdbId) FROM '/data/links.csv' DELIMITER ',' CSV HEADER;

-- Import tags table
COPY tags (userId, movieId, tag, timestamp) FROM '/data/tags.csv' DELIMITER ',' CSV HEADER;
UPDATE tags SET timestamp = to_timestamp(timestamp);

-- Import ratings table
COPY ratings (userId, movieId, rating, timestamp) FROM '/data/ratings.csv' DELIMITER ',' CSV HEADER;
UPDATE ratings SET timestamp = to_timestamp(timestamp);

-- Import genome_scores table
COPY genome_scores (movieId, tagId, relevance) FROM '/data/genome-scores.csv' DELIMITER ',' CSV HEADER;

-- Import genome_tags table
COPY genome_tags (tagId, tag) FROM '/data/genome-tags.csv' DELIMITER ',' CSV HEADER;