FROM golang:1.21-alpine AS builder

WORKDIR /app

COPY go.mod ./

RUN go mod download

COPY . .

RUN go mod tidy

# Build the Go binary securely and statically
RUN CGO_ENABLED=0 GOOS=linux go build -o quote-app .

FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/quote-app .
COPY static/ ./static/

EXPOSE 8080

CMD ["./quote-app"]
