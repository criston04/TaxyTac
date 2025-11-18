FROM golang:1.23-alpine AS builder

WORKDIR /src

# Copiar archivos de dependencias
COPY go.mod go.sum ./
RUN go mod download

# Copiar código fuente
COPY . .

# Build del binario
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /taxytac ./cmd

# Imagen final
FROM alpine:3.18

RUN apk add --no-cache ca-certificates

COPY --from=builder /taxytac /taxytac

EXPOSE 8080

ENTRYPOINT ["/taxytac"]
