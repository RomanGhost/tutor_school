## Deploy проекта
Клонируем проект:
```shell
git clone https://github.com/RomanGhost/tutor_school.git
```
Переходим в ветку **deploy**
```shell
git checkout deploy
```
Мержим ветку **master**
```shell
git merge master -m "merge branches"
```
С помощью **docker-compose** собираем контейнеры
```shell
docker-compose build
```
Запускаем проекты
```shell
docker-compose up -d
```