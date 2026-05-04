# Arquitectura de Ocari

Ocari sigue una arquitectura **Feature-first con Clean Layers**, combinando la organización por funcionalidad con la separación de responsabilidades en capas.

## Estructura de carpetas

```
lib/
├── core/                        # Código compartido por toda la app
│   ├── theme/                   # AppTheme, AppColors, AppTextStyles
│   ├── router/                  # Configuración de go_router
│   ├── widgets/                 # Componentes reutilizables (OcariButton, etc.)
│   └── utils/                   # Helpers, extensiones, constantes
│
├── features/                    # Cada feature es un módulo autónomo
│   ├── auth/                    # Autenticación y sesión
│   │   ├── data/
│   │   │   ├── repositories/    # Implementación concreta (Supabase)
│   │   │   └── datasources/     # Llamadas directas a la API
│   │   ├── domain/
│   │   │   ├── models/          # Entidades del negocio (User, etc.)
│   │   │   └── repositories/    # Interfaces (contratos abstractos)
│   │   └── presentation/
│   │       ├── screens/         # LoginScreen, RegisterScreen
│   │       ├── widgets/         # Widgets propios de auth
│   │       └── providers/       # Riverpod providers de esta feature
│   │
│   ├── songs/                   # Biblioteca de canciones
│   │   ├── data/
│   │   ├── domain/
│   │   │   └── models/          # Song, Difficulty, Fingering
│   │   └── presentation/
│   │       ├── screens/         # SongsScreen
│   │       ├── widgets/         # SongCard, DifficultyBadge
│   │       └── providers/
│   │
│   └── player/                  # Reproductor con ocarina animada
│       ├── data/
│       ├── domain/
│       │   └── models/          # PlayerState, Note, FingeringMap
│       └── presentation/
│           ├── screens/         # PlayerScreen
│           ├── widgets/         # OcarinaCanvas, NotesTrack, TransportBar
│           └── providers/       # playerProvider, audioProvider
│
└── main.dart
```

## Las tres capas de cada feature

### `presentation/` — UI y estado local
Todo lo que el usuario ve e interactúa. Los **providers de Riverpod** viven aquí y son el puente entre la UI y el dominio. Las pantallas y widgets solo consumen providers — nunca llaman repositorios directamente.

### `domain/` — Reglas del negocio
El corazón de la feature. Contiene los **modelos** (entidades puras en Dart, sin dependencia de Flutter ni de Supabase) y las **interfaces de repositorio** (contratos abstractos). Esta capa no sabe nada de la base de datos ni de la UI.

### `data/` — Acceso a datos
Implementa los contratos definidos en `domain/`. Aquí viven las llamadas reales a Supabase, la lectura de archivos JSON de digitación, y el manejo de caché local.

## Gestor de estado — Riverpod

Ver [`core/STATE_MANAGEMENT.md`](./core/STATE_MANAGEMENT.md) para la decisión completa y ejemplos de uso.

## Reglas de oro

1. **La dependencia siempre fluye hacia adentro:** `presentation` puede conocer `domain`, pero `domain` nunca conoce `presentation` ni `data`.
2. **Un provider por responsabilidad** — evitar providers que hacen demasiado.
3. **Sin lógica de negocio en los widgets** — toda lógica va en el provider o en el dominio.
4. **Modelos inmutables** — usar `freezed` para todas las entidades de dominio.