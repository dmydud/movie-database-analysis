-- import movies table
COPY movies (movieId, title, genres) FROM '/data/movies.csv' DELIMITER ',' CSV HEADER;

-- import links table
COPY links (movieId, imdbId, tmdbId) FROM '/data/links.csv' DELIMITER ',' CSV HEADER;

-- import tags table
ALTER TABLE tags ALTER COLUMN timestamp TYPE TEXT;
COPY tags (userId, movieId, tag, timestamp) FROM '/data/tags.csv' DELIMITER ',' CSV HEADER;
UPDATE tags SET timestamp = to_timestamp(timestamp::bigint);

-- import ratings table
ALTER TABLE ratings ALTER COLUMN timestamp TYPE TEXT;
COPY ratings (userId, movieId, rating, timestamp) FROM '/data/ratings.csv' DELIMITER ',' CSV HEADER;
UPDATE ratings SET timestamp = to_timestamp(timestamp::bigint);