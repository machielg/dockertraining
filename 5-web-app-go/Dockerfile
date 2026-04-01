FROM golang:1.16-buster

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

# Build application binary
RUN go build -o /web-app-ping

EXPOSE 8080

USER 1000

CMD [ "/web-app-ping" ]