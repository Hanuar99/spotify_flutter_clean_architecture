# 🎵 Spotify Clone - Flutter

Aplicación móvil desarrollada en Flutter inspirada en Spotify, construida aplicando principios de Clean Architecture, BLoC Pattern y buenas prácticas de desarrollo profesional.

---

## 🚀 Tecnologías Utilizadas

- Flutter
- Dart
- BLoC / Cubit
- Clean Architecture
- Dependency Injection (GetIt)
- GoRouter
- Firebase
- REST APIs
- Unit Testing & Widget Testing
- Mockito / Mocktail / bloc_test

---

## 🧩 Arquitectura del Proyecto

El proyecto está construido siguiendo Clean Architecture con una separación clara en capas:

```
lib/
├── core/
├── data/
├── domain/
├── presentation/
```

### Capas

- **Presentation**: Cubits, Pages y Widgets  
- **Domain**: Entities, UseCases y Repositories  
- **Data**: DataSources e Implementaciones de repositorio  
- **Core**: Inyección de dependencias, rutas y utilidades  

---

## 🧪 Testing

La aplicación implementa una estrategia de testing profesional:

- Unit Tests para Cubits y lógica de negocio  
- Widget Tests para validación de UI  
- Mocks con Mockito y Mocktail  
- Cobertura actual aproximada: **75%**

### Ejecutar Tests

```bash
flutter test
```

### Generar cobertura

```bash
flutter test --coverage
```

---

## 📱 Funcionalidades

- Autenticación de usuario  
- Reproducción de canciones  
- Listado de canciones recientes  
- Gestión de favoritos  
- Perfil de usuario  
- Navegación con GoRouter  
- Manejo de estados con BLoC  
- Integración con APIs  

---

## 🔧 Instalación

1. Clonar el repositorio

```bash
git clone https://github.com/Hanuar99/spotify_flutter_clean_architecture.git
```

2. Instalar dependencias

```bash
flutter pub get
```

3. Ejecutar la aplicación

```bash
flutter run
```

---

## 📂 Estructura del Proyecto

```
lib/
├── core/
│   ├── di/
│   ├── routes/
│   ├── theme/
│   └── usecases/
│
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
│
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
│
└── presentation/
    ├── blocs/
    ├── pages/
    └── widgets/
```

---

## 🎯 Buenas Prácticas Implementadas

- Principios SOLID  
- Separación por responsabilidades  
- Arquitectura escalable  
- Inyección de dependencias  
- Manejo de estados con BLoC  
- Testing automatizado  
- Código limpio y mantenible  

---

## 📌 Autor

**Hanuar Rubio**  
Flutter Mobile Developer  
Colombia  

LinkedIn: https://www.linkedin.com/in/hanuar-rubio/  

---

## 📄 Licencia

Este proyecto es de uso educativo y demostrativo para portafolio profesional.
