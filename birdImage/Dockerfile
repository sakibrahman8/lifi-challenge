FROM golang:1.22-alpine AS build
WORKDIR /app
COPY go.mod ./
COPY . ./
RUN go build -o getBirdImage
FROM alpine:latest
WORKDIR /app
COPY --from=build /app/getBirdImage .
RUN addgroup -S birdapp && adduser -S birduser -G birdapp
USER birduser
EXPOSE 4200
CMD ["./getBirdImage"]
