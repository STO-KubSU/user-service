# 1. Указываем базовый образ Go
FROM golang:1.23-alpine AS build

# 2. Устанавливаем рабочую директорию внутри контейнера
WORKDIR /app

# 3. Копируем все файлы проекта в контейнер
COPY . .

# 4. Загружаем зависимости Go (используется go.mod)
RUN go mod download

# 5. Компилируем Go-приложение
RUN go build -o user-service ./cmd/user-service

# 6. Используем минимальный образ для финального контейнера
FROM alpine:latest

# 7. Устанавливаем рабочую директорию для финального контейнера
WORKDIR /root/

# 8. Копируем скомпилированный бинарник из предыдущего этапа
COPY --from=build /app/user-service .

# 9. Определяем команду для запуска приложения
CMD ["./user-service"]
