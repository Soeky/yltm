# Build Stage
FROM golang:1.20 AS builder

# Setze das Arbeitsverzeichnis auf /app/backend
WORKDIR /app/backend

# Kopiere nur das backend-Verzeichnis
COPY backend/ .

# Installiere Abhängigkeiten und baue das Projekt
RUN go mod download
RUN go build -o server main.go


# Final Stage with Alpine
FROM alpine:latest
RUN apk --no-cache add libc6-compat  # Fügt GLIBC-Kompatibilität hinzu
COPY --from=builder /app/backend/server /server

EXPOSE 8080
CMD ["/server"]
