### Stage 1: Compile Binary

# Start from Golang Alpine base image / Label image as "builder"
FROM golang:1.21-alpine AS builder

# Create build directory
RUN mkdir /build

# Define working directory inside container
WORKDIR /build

# Copy Go module files
COPY \
  golang-source-code/go.mod \
  golang-source-code/go.sum \
  ./

# Downloads Dependencies
RUN go mod download

# Copy the remaining source files
COPY golang-source-code/main.go ./

# Compile Go file into an executable binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o binary-example-file .



### Stage 2: Final Container

# Start from Alpine base image
FROM alpine:latest

# Creates system user "appuser" / no PW
RUN adduser -S -D -H -h /app appuser

# Switch to "appuser"
USER appuser

# Copy "helloworld" binary from the "compile" stage to the "/app" directory in the container
COPY --from=builder /build/binary-example-file /app/

# Copy "views" directory from the build context (host) into "/app/views" in the container
COPY golang-source-code/views/ /app/views

# Define working directory
WORKDIR /app

# Expose port 8080 for the application
EXPOSE 8080

# Execute the Go binary when the container starts
ENTRYPOINT ["./binary-example-file"]