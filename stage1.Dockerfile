# This serves as build container.
# Without this, all go packages would be downloaded over and over again,
# each time you build the bouncer image.

 
FROM golang:1.21.3-alpine
 
#RUN apk add --no-cache git

WORKDIR /go/src/app

COPY ./go.mod ./go.mod

RUN go mod download
