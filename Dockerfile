# --- STAGE 1: Build ---
FROM golang:1.21-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the go.mod file and download dependencies
COPY go.mod ./
RUN go mod download

# Copy the rest of the source code
COPY . .

# Build the application into a tiny binary called 'main'
RUN go build -o main .

# --- STAGE 2: Run ---
FROM alpine:latest

# Set working directory
WORKDIR /root/

# Copy ONLY the binary from the builder stage
COPY --from=builder /app/main .

# Expose port 8080 to the outside world
EXPOSE 8080

# Command to run the executable
CMD ["./main"]