FROM golang:1.22-alpine AS build
WORKDIR /app
COPY go.mod ./
RUN go get github.com/prometheus/client_golang/prometheus
RUN go get github.com/prometheus/client_golang/prometheus/promhttp
RUN go mod tidy
COPY . ./
RUN go build -o getBird
FROM alpine:latest
WORKDIR /app
COPY --from=build /app/getBird .
RUN addgroup -S birdapp && adduser -S birduser -G birdapp
USER birduser
EXPOSE 4201
CMD ["./getBird"]
