# Используем официальный образ OpenJDK для сборки
FROM gradle:7.6-jdk17 AS build

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем файлы проекта
COPY . .

# Собираем приложение с помощью Gradle
RUN gradle build --no-daemon -x test

# Используем официальный образ OpenJDK для запуска
FROM openjdk:17-jdk-slim

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем скомпилированный jar файл из предыдущего шага
COPY --from=build /app/build/libs/*.jar app.jar

# Открываем порт 8080 для приложения
EXPOSE 8080

# Запускаем приложени
CMD ["java", "-jar", "app.jar"]

