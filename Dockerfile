# Use official PostgreSQL image from Docker Hub
FROM postgres:latest

# Set environment variables
ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD password
ENV POSTGRES_DB moviedb

# Copy SQL script to initialize database
COPY create-tables.sql /docker-entrypoint-initdb.d/

# Expose PostgreSQL port
EXPOSE 5432