# 🎵 Spotify Clone — Flutter Clean Architecture

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?logo=firebase&logoColor=black)
![BLoC](https://img.shields.io/badge/BLoC%2FCubit-pattern-blue)
![License](https://img.shields.io/badge/Licencia-Educativa-green)

Aplicación móvil desarrollada en **Flutter** inspirada en Spotify. Implementa **Clean Architecture**, el patrón **BLoC/Cubit** para la gestión de estados y buenas prácticas de desarrollo profesional. Usa **Firebase** como backend (autenticación y base de datos) y **just_audio** para la reproducción de audio.

---

## 📋 Tabla de Contenidos

- [Funcionalidades](#-funcionalidades)
- [Capturas de Pantalla](#-capturas-de-pantalla)
- [Arquitectura del Proyecto](#-arquitectura-del-proyecto)
- [Estructura de Directorios](#-estructura-de-directorios)
- [Dependencias Principales](#-dependencias-principales)
- [Configuración e Instalación](#-configuración-e-instalación)
- [Configuración de Firebase](#-configuración-de-firebase)
- [Navegación y Rutas](#-navegación-y-rutas)
- [Gestión de Estado (BLoC/Cubit)](#-gestión-de-estado-bloccubit)
- [Inyección de Dependencias](#-inyección-de-dependencias)
- [Testing](#-testing)
- [Buenas Prácticas](#-buenas-prácticas-implementadas)
- [Autor](#-autor)
- [Licencia](#-licencia)

---

## 📱 Funcionalidades

| Funcionalidad | Descripción |
|---|---|
| 🔐 Autenticación | Registro e inicio de sesión con Firebase Auth |
| 🎵 Reproducción de audio | Reproducir, pausar y controlar canciones con `just_audio` |
| 🆕 Canciones recientes | Listado dinámico de las novedades musicales |
| 📋 Lista de reproducción | Vista de playlist completa con todas las canciones |
| ❤️ Favoritos | Agregar/eliminar canciones de favoritos en Firestore |
| 👤 Perfil de usuario | Vista de datos del usuario y sus canciones favoritas |
| 🌗 Tema claro/oscuro | Alternancia de tema persistida con `hydrated_bloc` |
| 🧭 Navegación declarativa | Rutas con `GoRouter` y guardas de autenticación |

---

## 📸 Capturas de Pantalla

> Las capturas se pueden agregar en la carpeta `assets/images/screenshots/` y referenciar aquí.

---

## 🧩 Arquitectura del Proyecto

El proyecto sigue los principios de **Clean Architecture** con tres capas bien definidas, más una capa `core` de soporte:

```
┌────────────────────────────────────────────────┐
│              Presentation Layer                │
│  (Pages, Cubits/Blocs, Widgets)                │
├────────────────────────────────────────────────┤
│               Domain Layer                     │
│  (Entities, Use Cases, Repository Interfaces)  │
├────────────────────────────────────────────────┤
│                Data Layer                      │
│  (Data Sources, Models, Repository Impls)      │
├────────────────────────────────────────────────┤
│                Core Layer                      │
│  (DI, Router, Theme, Failure, UseCase base)    │
└────────────────────────────────────────────────┘
```

### Descripción de Capas

#### 🖼️ Presentation
Contiene todo lo relacionado con la UI:
- **Pages**: Pantallas individuales de la app (`SplashPage`, `HomePage`, `SigninPage`, `ProfilePage`, `SongPlayerPage`, etc.).
- **Cubits**: Gestión de estado reactiva con `flutter_bloc`. Cada feature tiene su(s) cubit(s) propio(s).
- **Widgets**: Componentes reutilizables compartidos entre pantallas.

#### 🧠 Domain
El núcleo de la lógica de negocio. Es **completamente independiente** de Flutter y de Firebase:
- **Entities**: Modelos puros del dominio (`SongEntity`, `UserEntity`).
- **Use Cases**: Cada acción de negocio es un caso de uso independiente (por ejemplo `SigninUseCase`, `GetNewsSongsUseCase`, `AddOrRemoveFavoriteUsecase`).
- **Repository Interfaces**: Contratos abstractos que la capa de datos debe implementar.

#### 🗄️ Data
Implementa los contratos definidos en el dominio:
- **Sources**: Servicios concretos de Firebase Auth (`AuthFirebaseServiceImpl`) y Firestore (`SongFirebaseServiceImpl`), y la fuente de audio (`AudioPlayerDataSourceImpl`).
- **Models**: Objetos de transferencia de datos (por ejemplo `UserModel`, `SongModel`) con métodos `fromJson`/`toJson`.
- **DTOs**: Objetos de request (por ejemplo `CreateUserDto`, `SigninUserReq`).
- **Repositories**: Implementaciones de los contratos del dominio.

#### ⚙️ Core
Infraestructura transversal a toda la app:
- **configs/theme**: `AppTheme`, `AppColors` — soporte para modo claro y oscuro.
- **configs/constants**: `AppUrls` — URLs y constantes globales.
- **router**: `AppRouter` (GoRouter), `AppRoutes` (constantes de rutas), `RouteGuards` (protección de rutas por autenticación).
- **failure**: Clases `Failure` y `AudioFailure` para manejo funcional de errores con `dartz`.
- **usecase**: Interfaces base `UseCase<Type, Params>` y `NoParamsUseCase<Type>`.

---

## 📂 Estructura de Directorios

```
lib/
├── main.dart                        # Punto de entrada, inicializa Firebase y BLoC
├── main_app.dart                    # Widget raíz con MaterialApp y GoRouter
├── service_locator.dart             # Registro de todas las dependencias con GetIt
├── firebase_options.dart            # Configuración de Firebase por plataforma
│
├── core/
│   ├── configs/
│   │   ├── constants/
│   │   │   └── app_urls.dart
│   │   └── theme/
│   │       ├── app_colors.dart
│   │       ├── app_theme.dart
│   │       ├── app_theme_colors.dart
│   │       └── app_theme_extensions.dart
│   ├── failure/
│   │   └── failure.dart             # Failure, AudioFailure
│   ├── router/
│   │   ├── app_router.dart          # Definición de GoRouter
│   │   ├── app_routes.dart          # Constantes de rutas
│   │   └── route_guards.dart        # AuthGuard
│   └── usecase/
│       └── usecase.dart             # UseCase<T,P>, NoParamsUseCase<T>
│
├── common/
│   ├── bloc/
│   │   └── favorite_button/         # FavoriteButtonCubit (compartido)
│   ├── helpers/
│   └── widgets/
│
├── data/
│   ├── dtos/
│   │   └── auth/
│   │       └── create_user_dto.dart
│   ├── models/
│   │   ├── auth/
│   │   │   ├── signin_user_req.dart
│   │   │   └── user_model.dart
│   │   └── song/
│   │       └── song_model.dart
│   ├── repository/
│   │   ├── audio/
│   │   ├── auth/
│   │   └── song/
│   └── sources/
│       ├── audio/
│       │   └── audio_player_datasource.dart
│       ├── auth/
│       │   └── auth_firebase_service.dart
│       └── song/
│           └── song_firebase_service.dart
│
├── domain/
│   ├── entities/
│   │   ├── auth/
│   │   │   └── user_entity.dart
│   │   └── song/
│   │       └── song_entity.dart
│   ├── params/
│   ├── repository/
│   │   ├── audio/
│   │   ├── auth/
│   │   └── song/
│   └── usecases/
│       ├── audio/
│       │   ├── get_song_duration_stream_usecase.dart
│       │   ├── get_song_position_stream_usecase.dart
│       │   ├── is_song_playing_usecase.dart
│       │   ├── load_song_usecase.dart
│       │   └── play_or_pause_song_usecase.dart
│       ├── auth/
│       │   ├── get_user_usecase.dart
│       │   ├── is_user_logged_in_usecase.dart
│       │   ├── signin_usecase.dart
│       │   └── signup_usecase.dart
│       └── song/
│           ├── add_or_remove_favorite_usecase.dart
│           ├── get_favorites_song_usecase.dart
│           ├── get_news_songs_usecase.dart
│           ├── get_play_list_usecase.dart
│           └── is_favorite_usecase.dart
│
├── generated/                       # Generado por flutter_gen
│
└── presentation/
    ├── auth/
    │   ├── cubits/
    │   │   └── signin/
    │   └── pages/
    │       ├── signin_page.dart
    │       ├── signup_page.dart
    │       └── signup_or_siginn_page.dart
    ├── choose_mode/
    │   ├── cubit/                   # ThemeCubit (modo claro/oscuro)
    │   └── pages/
    │       └── choose_mode_page.dart
    ├── home/
    │   ├── cubit/
    │   │   ├── news_songs_cubit.dart
    │   │   └── play_list_cubit.dart
    │   ├── pages/
    │   │   └── home_page.dart
    │   └── widgets/
    ├── intro/
    │   └── pages/
    │       └── get_started_page.dart
    ├── profile/
    │   ├── blocs/
    │   │   ├── favorite_songs/
    │   │   └── profile_info_cubit/
    │   └── pages/
    │       └── profile_page.dart
    ├── song_player/
    │   ├── bloc/
    │   │   └── cubit/
    │   │       └── song_player_cubit.dart
    │   └── pages/
    │       └── song_player_page.dart
    └── splash/
        └── pages/
            └── splash_page.dart
```

---

## 📦 Dependencias Principales

### Runtime

| Paquete | Versión | Propósito |
|---|---|---|
| `flutter_bloc` | — | Gestión de estado con BLoC/Cubit |
| `hydrated_bloc` | — | Persistencia automática del estado del Cubit |
| `go_router` | ^16.1.0 | Navegación declarativa con soporte para guardas |
| `get_it` | — | Inyección de dependencias (Service Locator) |
| `firebase_core` | — | Inicialización de Firebase |
| `firebase_auth` | — | Autenticación de usuarios |
| `cloud_firestore` | — | Base de datos en tiempo real |
| `just_audio` | — | Reproducción de audio desde URLs |
| `dartz` | — | Programación funcional (`Either`, `Option`) |
| `equatable` | — | Comparación de objetos por valor |
| `flutter_svg` | ^2.2.0 | Renderizado de imágenes SVG |
| `path_provider` | — | Acceso a directorios del sistema de archivos |

### Desarrollo y Testing

| Paquete | Propósito |
|---|---|
| `bloc_test` | Utilidades para testear Cubits/Blocs |
| `mocktail` | Mocks y stubs sin generación de código |
| `mockito` | Mocks con generación de código (`build_runner`) |
| `firebase_auth_mocks` | Mocks de Firebase Auth para tests |
| `fake_cloud_firestore` | Implementación fake de Firestore para tests |
| `network_image_mock` | Mock para imágenes de red en widget tests |
| `flutter_gen` | Generación de código para assets tipados |
| `flutter_lints` | Reglas de linting recomendadas para Flutter |

---

## 🔧 Configuración e Instalación

### Prerrequisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.x
- [Dart SDK](https://dart.dev/get-dart) ≥ 3.x
- Una cuenta de [Firebase](https://firebase.google.com/) con un proyecto activo
- Android Studio / VS Code con extensiones de Flutter

### Pasos de Instalación

1. **Clonar el repositorio**

```bash
git clone https://github.com/Hanuar99/spotify_flutter_clean_architecture.git
cd spotify_flutter_clean_architecture
```

2. **Instalar dependencias**

```bash
flutter pub get
```

3. **Regenerar assets y mocks** *(si es necesario)*

```bash
dart run build_runner build --delete-conflicting-outputs
```

4. **Ejecutar la aplicación**

```bash
flutter run
```

---

## 🔥 Configuración de Firebase

El proyecto usa Firebase como backend. Sigue estos pasos para configurarlo en tu propio proyecto:

1. Crea un proyecto en [Firebase Console](https://console.firebase.google.com/).

2. Registra tu app para Android y/o iOS/Web siguiendo las instrucciones de Firebase.

3. Instala la CLI de Firebase y FlutterFire CLI:

```bash
npm install -g firebase-tools
dart pub global activate flutterfire_cli
```

4. Genera el archivo `firebase_options.dart`:

```bash
flutterfire configure
```

5. Habilita los siguientes servicios en Firebase Console:
   - **Authentication** → Método: Correo electrónico/contraseña
   - **Cloud Firestore** → Crea las colecciones `Users` y `Songs`

### Estructura esperada de Firestore

**Colección `Users`**
```
Users/
  {uid}/
    name: string
    email: string
    uid: string
```

**Colección `Songs`**
```
Songs/
  {songId}/
    title: string
    artist: string
    duration: number
    release: timestamp
    coverUrl: string
    audioUrl: string
```

---

## 🧭 Navegación y Rutas

La navegación se gestiona con **GoRouter**. Todas las rutas están definidas como constantes en `AppRoutes` y configuradas en `AppRouter`.

| Ruta | Constante | Descripción |
|---|---|---|
| `/splash` | `AppRoutes.splash` | Pantalla de carga inicial con redirección automática |
| `/get-started` | `AppRoutes.getStarted` | Pantalla de bienvenida |
| `/choose-mode` | `AppRoutes.chooseMode` | Selección de tema claro/oscuro |
| `/signup-or-signin` | `AppRoutes.signupOrSignin` | Elección entre registrarse o iniciar sesión |
| `/signin` | `AppRoutes.signin` | Formulario de inicio de sesión |
| `/signup` | `AppRoutes.signup` | Formulario de registro |
| `/home` | `AppRoutes.home` | Pantalla principal con novedades y playlist |
| `/song-player` | `AppRoutes.songPlayer` | Reproductor de canción (recibe `SongEntity` como `extra`) |
| `/profile` | `AppRoutes.profile` | Perfil de usuario y canciones favoritas |

### Guarda de Autenticación

`AuthGuard` intercepta la ruta `/splash` y redirige:
- A la pantalla de bienvenida (`/get-started`) si el usuario **no** está autenticado.
- Al **home** (`/home`) si el usuario **ya** está autenticado.

---

## 🔄 Gestión de Estado (BLoC/Cubit)

Cada feature gestiona su propio estado de forma aislada:

| Cubit / Bloc | Feature | Responsabilidad |
|---|---|---|
| `ThemeCubit` | choose_mode | Alterna y persiste el tema claro/oscuro |
| `SigninCubit` | auth | Maneja el flujo de inicio de sesión |
| `NewsSongsCubit` | home | Carga la lista de canciones recientes |
| `PlayListCubit` | home | Carga la lista de reproducción completa |
| `SongPlayerCubit` | song_player | Controla reproducción, posición y duración |
| `FavoriteButtonCubit` | common | Alterna el estado de favorito de una canción |
| `ProfileInfoCubit` | profile | Carga los datos del usuario autenticado |
| `FavoriteSongsCubit` | profile | Carga las canciones favoritas del usuario |

El manejo de errores utiliza el tipo `Either<Failure, T>` de la librería `dartz`, haciendo que los fallos sean explícitos y tratados de forma funcional en los Use Cases y Cubits.

---

## 💉 Inyección de Dependencias

El proyecto usa **GetIt** como Service Locator. Todo el grafo de dependencias se registra en `service_locator.dart` al inicio de la aplicación con el siguiente orden:

1. **Firebase** (externos: `FirebaseAuth`, `FirebaseFirestore`)
2. **Data Sources** (servicios concretos de Firebase y Audio)
3. **Repositories** (implementaciones de los contratos del dominio)
4. **Use Cases** (lógica de negocio)
5. **Cubits** (estado de la UI)
6. **Router** (`AuthGuard`, `AppRouter`)

---

## 🧪 Testing

La aplicación implementa una estrategia de testing profesional:

- ✅ **Unit Tests** para Cubits, Use Cases y lógica de negocio
- ✅ **Widget Tests** para validación de componentes UI
- ✅ **Mocks** con `mocktail` y `mockito`
- ✅ **Fakes** de Firebase (`firebase_auth_mocks`, `fake_cloud_firestore`)
- 📊 **Cobertura actual aproximada: 75%**

### Ejecutar todos los tests

```bash
flutter test
```

### Generar reporte de cobertura

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Estructura de tests

```
test/
├── app/
│   ├── common/
│   ├── data/
│   ├── domain/
│   ├── presentation/
│   └── main_app_test.dart
├── core/
│   ├── configs/
│   └── router/
├── mocks.dart
├── mocks.mocks.dart
└── service_locator_test.dart
```

---

## 🎯 Buenas Prácticas Implementadas

- ✅ Principios **SOLID**
- ✅ **Separación de responsabilidades** por capa y feature
- ✅ **Arquitectura escalable** — agregar un nuevo feature no impacta los existentes
- ✅ **Inyección de dependencias** con GetIt
- ✅ **Manejo funcional de errores** con `Either` (dartz)
- ✅ **Persistencia de estado** con `hydrated_bloc`
- ✅ **Navegación declarativa** con GoRouter y guardas
- ✅ **Testing automatizado** con cobertura de ~75%
- ✅ **Código generado** para assets (flutter_gen) y mocks (build_runner)
- ✅ **Linting** con `flutter_lints`

---

## 📌 Autor

**Hanuar Rubio**  
Flutter Mobile Developer — Colombia

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Hanuar%20Rubio-0A66C2?logo=linkedin&logoColor=white)](https://www.linkedin.com/in/hanuar-rubio/)

---

## 📄 Licencia

Este proyecto es de uso **educativo y demostrativo** para portafolio profesional.
