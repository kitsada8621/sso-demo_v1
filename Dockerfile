FROM golang:1.23-alpine

WORKDIR /app

RUN apk add --no-cache git

COPY go.mod go.sum ./

RUN go mod download

COPY . /app

RUN go build -o main ./cmd/api

CMD ["./main"]
