FROM golang:latest as build

# Set the application name
# This will result in your application
# living in/go/src/*your application name*
# directory within your container
ENV APPLICATION_NAME=app

# Set necessary environmet variables needed for our image
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

# Move to working directory /build
WORKDIR /build/src

## Copy and download dependency using go mod
COPY ./src/go.mod .
COPY ./src/go.sum .
RUN go mod download

## Custom sources
RUN curl -L https://packagecloud.io/golang-migrate/migrate/gpgkey | apt-key add -
RUN touch /etc/apt/sources.list.d/golang-migrate_migrate.list
RUN echo "deb https://packagecloud.io/golang-migrate/migrate/debian/ buster main\n" \
    "deb-src https://packagecloud.io/golang-migrate/migrate/debian/ buster main\n" \
    > /etc/apt/sources.list.d/golang-migrate_migrate.list

## Update our list
RUN apt-get update -y
RUN apt-get upgrade -y

## Install os dependancies
RUN apt-get install -y \
    debian-archive-keyring \
    curl \
    gnupg \
    apt-transport-https \
    git \
    wget \
    vim \
    lsb-release

## Install migrate binary for for go
RUN apt-get install -y migrate

# Add our application folder and change to it for working
ADD ./src /go/src/${APPLICATION_NAME}
WORKDIR /go/src/${APPLICATION_NAME}

# Build our go application
RUN go get
RUN go build -o main /go/src/${APPLICATION_NAME}

# Export necessary port
EXPOSE 3000

# Run our go application
RUN ln -s /go/src/${APPLICATION_NAME}/main /go/src/docker_entrypoint.sh
CMD ["/go/src/docker_entrypoint.sh"]