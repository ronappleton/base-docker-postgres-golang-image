# Base Docker Image
## A base image to use for go and postgre projects

This project is a simple dockerfile setup to use the latest golang version and postgres database from their official image respositories.

To set your application name alter

`ENV APPLICATION_NAME=app`

Its setup for your project files to live in the src folder

Go Migrate is installed as binary for running your migrations.

The `.docker/.postgres/data` folder will persists between builds so you avoid losing your database, delete the data folder if you want a clean build.

# Running

Docker compose file is included, so `docker-composer up -d [--build]`
