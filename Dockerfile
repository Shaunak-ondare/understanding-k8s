# Build stage
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Copy the go.mod and initialization files
COPY go.mod ./
# Download dependencies (none currently, but good practice)
RUN go mod download

# Copy the rest of the application source code 
COPY . .

# Tidy dependencies before building
RUN go mod tidy

# Build the Go binary securely and statically
RUN CGO_ENABLED=0 GOOS=linux go build -o quote-app .

# Final stage
FROM alpine:latest

WORKDIR /app

# Copy the generated binary and the static folder holding the UI
COPY --from=builder /app/quote-app .
COPY static/ ./static/

# The application listens on port 8080
EXPOSE 8080

# Command to run the application
CMD ["./quote-app"]
