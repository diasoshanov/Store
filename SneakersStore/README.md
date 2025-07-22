# SneakersStore - Магазин кроссовок

Мобильное приложение для покупки кроссовок, построенное с использованием SwiftUI, Firebase и архитектуры MVVM.

## Функциональность

### 🔐 Авторизация
- Регистрация новых пользователей
- Вход в существующий аккаунт
- Безопасная аутентификация через Firebase Auth

### 🎯 Онбординг
- 3 страницы знакомства с приложением
- Плавные переходы между страницами
- Красивый дизайн с анимациями

### 🛍️ Каталог товаров
- Отображение кроссовок в виде сетки
- Поиск по названию и бренду
- Фильтрация по категориям
- Детальная информация о товаре
- Выбор размера и цвета

### 🛒 Корзина покупок
- Добавление товаров в корзину
- Изменение количества
- Удаление товаров
- Подсчет общей стоимости
- Оформление заказа

### 👤 Профиль пользователя
- Информация о пользователе
- Редактирование профиля
- История заказов
- Настройки приложения
- Выход из аккаунта

## Архитектура

Приложение построено с использованием архитектуры **MVVM (Model-View-ViewModel)**:

- **Models**: Структуры данных для кроссовок, корзины и пользователей
- **Views**: SwiftUI представления для UI
- **ViewModels**: Бизнес-логика и управление состоянием
- **Services**: Firebase сервисы для работы с данными

## Технологии

- **SwiftUI** - современный фреймворк для создания UI
- **Firebase** - бэкенд-сервисы:
  - Firebase Auth - аутентификация
  - Firestore - база данных
  - Firebase Storage - хранение файлов
- **MVVM** - архитектурный паттерн
- **Combine** - реактивное программирование

## Установка и настройка

### 1. Клонирование репозитория
```bash
git clone <repository-url>
cd SneakersStore
```

### 2. Настройка Firebase

1. Создайте проект в [Firebase Console](https://console.firebase.google.com/)
2. Добавьте iOS приложение в проект
3. Скачайте файл `GoogleService-Info.plist`
4. Замените существующий файл `GoogleService-Info.plist` в проекте
5. Включите Authentication в Firebase Console
6. Настройте Firestore Database

### 3. Установка зависимостей

Откройте проект в Xcode и добавьте Firebase SDK через Swift Package Manager:

1. File → Add Package Dependencies
2. Введите URL: `https://github.com/firebase/firebase-ios-sdk.git`
3. Выберите следующие продукты:
   - FirebaseAuth
   - FirebaseFirestore
   - FirebaseStorage

### 4. Настройка Firestore

Создайте следующие коллекции в Firestore:

#### Коллекция `users`
```json
{
  "email": "string",
  "name": "string",
  "phone": "string (optional)",
  "address": "string (optional)",
  "profileImageURL": "string (optional)"
}
```

#### Коллекция `sneakers`
```json
{
  "name": "string",
  "brand": "string",
  "price": "number",
  "description": "string",
  "imageURL": "string",
  "sizes": ["array of strings"],
  "colors": ["array of strings"],
  "category": "string",
  "inStock": "boolean",
  "rating": "number",
  "reviewsCount": "number"
}
```

#### Коллекция `carts`
```json
{
  "items": [
    {
      "id": "string",
      "sneaker": "sneaker object",
      "size": "string",
      "color": "string",
      "quantity": "number"
    }
  ],
  "updatedAt": "timestamp"
}
```

### 5. Запуск приложения

1. Откройте проект в Xcode
2. Выберите симулятор или устройство
3. Нажмите Run (⌘+R)

## Структура проекта

```
SneakersStore/
├── Models/
│   └── Sneaker.swift
├── ViewModels/
│   ├── AuthViewModel.swift
│   ├── CatalogViewModel.swift
│   └── CartViewModel.swift
├── Services/
│   └── FirebaseManager.swift
├── Views/
│   ├── Onboarding/
│   │   └── OnboardingView.swift
│   ├── Auth/
│   │   └── AuthView.swift
│   ├── Catalog/
│   │   ├── CatalogView.swift
│   │   ├── SneakerDetailView.swift
│   │   └── FilterView.swift
│   ├── Cart/
│   │   └── CartView.swift
│   └── Profile/
│       └── ProfileView.swift
├── MainTabView.swift
├── SneakersStoreApp.swift
└── GoogleService-Info.plist
```

## Основные компоненты

### AuthViewModel
Управляет аутентификацией пользователей:
- Регистрация и вход
- Отслеживание состояния авторизации
- Управление профилем пользователя

### CatalogViewModel
Управляет каталогом товаров:
- Загрузка данных из Firestore
- Фильтрация и поиск
- Добавление в корзину

### CartViewModel
Управляет корзиной покупок:
- Добавление/удаление товаров
- Изменение количества
- Синхронизация с Firestore

## Безопасность

- Все данные пользователей защищены Firebase Security Rules
- Пароли хешируются Firebase Auth
- Аутентификация через токены
- Безопасное хранение данных в Firestore

## Расширение функциональности

Возможные улучшения:
- Добавление избранного
- История заказов
- Уведомления
- Отзывы и рейтинги
- Интеграция с платежными системами
- Push-уведомления
- Офлайн режим

## Лицензия

MIT License

## Поддержка

При возникновении проблем создайте Issue в репозитории или обратитесь к разработчику. 