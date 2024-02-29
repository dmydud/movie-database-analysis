CREATE TABLE IF NOT EXISTS movies (
    movieId SERIAL PRIMARY KEY,
    title VARCHAR(255),
    genres VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS ratings (
    ratingId SERIAL PRIMARY KEY,
    userId INT,
    movieId INT REFERENCES movies(movieId),
    rating FLOAT,
    timestamp TIMESTAMP
);

CREATE TABLE IF NOT EXISTS tags (
    tagId SERIAL PRIMARY KEY,
    userId INT,
    movieId INT REFERENCES movies(movieId),
    tag VARCHAR(255),
    timestamp TIMESTAMP
);

CREATE TABLE IF NOT EXISTS links (
    movieId INT PRIMARY KEY REFERENCES movies(movieId),
    imdbId VARCHAR(20),
    tmdbId VARCHAR(20)
);

