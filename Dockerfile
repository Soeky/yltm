# Build Stage
FROM golang:1.20 AS builder

# Setze das Arbeitsverzeichnis auf /app/backend
WORKDIR /app/backend

# Kopiere nur das backend-Verzeichnis
COPY backend/ .

# Installiere Abhängigkeiten und baue das Projekt
RUN go mod download
RUN go build -o server main.go

# Final Image
FROM gcr.io/distroless/base-debian10
COPY --from=builder /app/backend/server /server

EXPOSE 8080
CMD ["/server"]
