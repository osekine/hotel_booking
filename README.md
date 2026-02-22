# Mini Booking System

GraphQL backend (Node.js + Prisma + Postgres)\
Flutter clients: **mobile** + **windows_widget**

------------------------------------------------------------------------

# 🚀 Первый запуск

## 1️⃣ Поднять backend

Из корня проекта:

``` bash
docker compose up --build
```

API будет доступен на:

    http://localhost:4000/graphql

------------------------------------------------------------------------

## 2️⃣ Первый запуск Flutter (ВАЖНО)

Расположение:

    client/flutter

Проект использует **melos** (monorepo с пакетами `domain`, `api_client`,
`mobile`, `windows_widget`).

### Установить melos

``` bash
dart pub global activate melos
```

### Bootstrap зависимостей

``` bash
cd project/client/flutter
melos bs
```

------------------------------------------------------------------------

## 3️⃣ Сгенерировать GraphQL клиент (опционально, уже включено в melos bs)

``` bash
cd client/flutter/windows_widget/packages/api_client
./tool/build.sh
```

------------------------------------------------------------------------

# 📱 Mobile App

Расположение:

    client/flutter/mobile

### iOS Simulator

``` bash
flutter run
```

### Android Emulator

``` bash
flutter run
```

API URL выбирается автоматически:

-   iOS → `http://localhost:4000/graphql`
-   Android → `http://10.0.2.2:4000/graphql`

Можно переопределить:

``` bash
flutter run --dart-define=API_HOST=192.168.1.50
```

------------------------------------------------------------------------

# 🪟 Windows Widget

Отдельное Flutter desktop-приложение (Windows), использующее тот же
`domain` и `api_client`.

Расположение:

    client/flutter/windows_widget

## Запуск

``` bash
cd client/flutter/windows_widget
flutter run -d windows
```

API URL определяется тем же конфигом, что и в mobile.

При необходимости:

``` bash
flutter run -d windows --dart-define=API_HOST=192.168.1.50
```

------------------------------------------------------------------------

# 🧱 Архитектура

## Backend

-   GraphQL API
-   Prisma + Postgres
-   Защита от пересечений бронирований на уровне БД

## Flutter структура

    apps/mobile
    apps/windows_widget
    packages/domain
    packages/api_client

### domain

-   Чистые сущности
-   Интерфейсы репозиториев
-   Failure-модель ошибок

### api_client

-   Реализация репозиториев через GraphQL
-   graphql_codegen
-   DTO → Domain мапперы

### mobile / windows_widget

-   Riverpod
-   go_router (mobile)
-   Desktop UI (windows_widget)
-   Платформенный auto-URL для API

------------------------------------------------------------------------

# ⚖️ Архитектурные решения

-   Отдельный `domain` пакет → чистая архитектура
-   Отдельный `api_client` → изоляция транспорта
-   graphql_codegen + build script → типобезопасность
-   Riverpod без overengineering → простота
-   Авто-выбор API URL → без хардкода localhost

------------------------------------------------------------------------

# 📌 Быстрый запуск (всё вместе)

``` bash
docker compose up --build

cd project/client/flutter
melos bs

# mobile
cd /mobile
flutter run

# windows widget
cd ../windows_widget
flutter run -d windows
```
