# Movie Database Analysis

This project aims to analyze the MovieLens dataset using PostgreSQL database for data storage and analysis. The dataset contains 5-star ratings and free-text tagging activity from [MovieLens](http://movielens.org), a movie recommendation service. It includes 100,000 ratings and 3,600 tag applications across 9,000 movies, created by 600 users between January 09, 1995, and September 24, 2018.

## Database

### Database Description

The PostgreSQL database schema used for this project consists of several tables to store different types of data:

- `ratings`: Contains information about user ratings for movies.
- `tags`: Stores user-generated metadata tags for movies.
- `movies`: Holds movie information including title, genres, and identifiers.
- `links`: Provides identifiers to link to other sources of movie data.

### Dataset Citation

To acknowledge the use of the MovieLens dataset in publications, please cite the following paper:

> F. Maxwell Harper and Joseph A. Konstan. 2015. The MovieLens Datasets: History and Context. ACM Transactions on Interactive Intelligent Systems (TiiS) 5, 4: 19:1–19:19. <https://doi.org/10.1145/2827872>

### Further Information

For more details about the MovieLens dataset and the GroupLens research group, visit the [MovieLens website](http://movielens.org) and the [GroupLens website](https://grouplens.org/).

### Database Access

The MovieLens dataset is not stored directly in this repository. You can download the dataset from the [GroupLens datasets page](https://grouplens.org/datasets/).

## Dockerized PostgreSQL

To simplify database setup, this project uses Docker to run a PostgreSQL container. The Dockerfile provided initializes a PostgreSQL database with the required schema and loads the MovieLens dataset.

### Docker Setup

1. Make sure you have Docker installed on your system.
2. Clone the repository:
```bash
git clone https://github.com/dmydud/movie-database-analysis
```
3. Build the Docker image:
```bash 
docker build -t moviedb-postgres .
```
4. Run the PostgreSQL container:
```bash 
docker run -d -p 5432:5432 --name postgres-container -v /path/to/data/folder:/data moviedb-postgres
```

**Note**: Replace `/absolute/path/to/data/folder` with the absolute path to your folder containing CSV files.

This command will start a PostgreSQL container named moviedb-container and expose port 5432 for database access.
5. Access the PostgreSQL database using your preferred client (e.g., pgAdmin, DBeaver) with the following credentials:
- **Host:** localhost
- **Port:** 5432
- **Database:** moviedb
- **Username:** postgres
- **Password:** password

## Requirements

To run this project, you'll need:

- Docker: To set up and run the PostgreSQL database container.
- PostgreSQL client: To interact with the database. You can use pgAdmin.
- Git: To clone the repository.

## Licensing

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

**Note**: The MovieLens dataset used in this project is provided under its own license from the University of Minnesota and the GroupLens Research Group. You are permitted to use the dataset for research purposes under the conditions outlined in its license. Please review the [license](LICENSE_MovieLens) for the MovieLens dataset before using it.