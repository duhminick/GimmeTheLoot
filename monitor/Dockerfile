FROM golang:alpine3.10
RUN apk update && apk add --no-cache gcc libc-dev bash git openssh
WORKDIR /go/src/app
COPY . .

RUN go get -d -v ./...
RUN go install -v ./...

CMD ["app"]
