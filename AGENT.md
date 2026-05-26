# AGENT.md — Ocari

Guía de contexto para agentes de IA trabajando en este repositorio.

---

## Qué es este proyecto

Ocari es una app móvil en Flutter para aprender a tocar la ocarina de 12 agujeros.
Inspirada en Simply Piano: reproduce una canción mientras muestra en tiempo real
qué agujeros presionar en una ilustración de la ocarina.

Stack: Flutter · Dart · Riverpod · go_router · Supabase · just_audio

---

## Estructura del proyecto

```
lib/
├── core/
│   ├── theme/        # AppTheme, AppColors, AppTextStyles
│   ├── router/       # go_router — rutas y redirects
│   └── widgets/      # Componentes reutilizables (OcariButton, etc.)
├── features/
│   ├── auth/         # Login, registro, sesión (Supabase Auth)
│   ├── songs/        # Lista de canciones y detalle
│   └── player/       # Reproductor + ocarina animada (CustomPainter)
└── main.dart
```

Cada feature sigue tres capas: `data/` → `domain/` → `presentation/`.
La dependencia siempre fluye hacia adentro. `presentation` conoce `domain`,
pero `domain` nunca conoce `presentation` ni `data`.

---

## Convenciones de código

### Nombrado

- Archivos: `snake_case.dart`
- Clases: `PascalCase`
- Variables y funciones: `camelCase`
- Providers de Riverpod: sufijo `Provider` o `Notifier` según el tipo
- Pantallas: sufijo `Screen` — ej. `LoginScreen`, `SongsScreen`
- Widgets reutilizables: prefijo `Ocari` — ej. `OcariButton`, `OcariTextField`

### Gestión de estado

Usamos Riverpod con generación de código (`@riverpod`).

- Datos remotos (auth, canciones): `AsyncNotifier`
- Estado sincrónico complejo (reproductor): `Notifier`
- Streams (sincronización audio): `StreamProvider`
- Repositorios y servicios: `Provider` simple

Nunca usar `setState` fuera de widgets verdaderamente locales.
Nunca poner lógica de negocio dentro de un widget.

### Modelos

Todos los modelos de dominio son inmutables con `freezed`.
Siempre incluir `fromJson` / `toJson` con `json_serializable`.
Después de modificar un modelo correr:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Imports

Orden: dart → flutter → paquetes externos → imports internos.
Usar imports relativos dentro de la misma feature.
Usar imports absolutos (`package:ocari/...`) entre features.

---

## Base de datos (Supabase)

Tres tablas principales:

| Tabla                | Descripción                                                   |
| -------------------- | ------------------------------------------------------------- |
| `profiles`           | Extiende `auth.users`. Datos públicos del usuario.            |
| `songs`              | Catálogo de canciones. Campo `notes_json` con array de notas. |
| `user_song_progress` | Progreso por usuario/canción. Unique en (user_id, song_id).   |

Row Level Security habilitado en todas las tablas.
Nunca hacer queries directas a `auth.users` — usar `profiles`.
Las credenciales van en variables de entorno, nunca hardcodeadas:

```bash
flutter run --dart-define-from-file=.env
```

---

## Rutas

| Ruta              | Pantalla     | Auth requerida |
| ----------------- | ------------ | -------------- |
| `/login`          | LoginScreen  | No             |
| `/songs`          | SongsScreen  | Sí             |
| `/player/:songId` | PlayerScreen | Sí             |

El redirect está en `core/router/app_router.dart`:
sin sesión → `/login`, con sesión → `/songs`.

---

## Ocarina — dominio específico

La ocarina de 12 agujeros tiene esta distribución de agujeros:

- 4 agujeros superiores (índice, medio, anular y meñique de la mano derecha, leídos de izquierda a derecha)
- 4 agujeros inferiores (meñique, anular, medio y índice de la mano izquierda, leídos de izquierda a derecha)
- 2 agujeros intermedios (medio izquierdo, anular derecho)
- 2 sub-agujeros en la parte posterior (pulgares)

La digitación de cada nota está en `assets/data/fingerings.json`.
Formato: `{ "note": "D5", "top": [1,1,1,1], "bot": [1,1,1,1], "inter":[0,0], "sub": [1,1] }`
donde `1 = presionado`, `0 = abierto`.

El rango de la ocarina de 12 agujeros es A4 → F6 (18 notas en afinación en Si♭).

---

## La pantalla más compleja: PlayerScreen

El reproductor tiene 4 elementos que deben estar sincronizados:

1. **Audio** — `just_audio` reproduce el archivo de la canción
2. **Carril de notas** — lista horizontal que avanza con el tiempo
3. **Ocarina animada** — `CustomPainter` pinta los agujeros según la nota activa
4. **Posición** — `audioPositionProvider` (StreamProvider) hace de puente entre audio y UI

La sincronización es: `posición en ms` → buscar nota activa en `notes_json` →
actualizar `PlayerNotifier` → rebuild de `OcarinaCanvas` y `NotesTrack`.

---

## Comandos frecuentes

```bash
# Correr la app
flutter run --dart-define-from-file=.env

# Análisis estático (debe pasar sin warnings antes de cada PR)
flutter analyze

# Tests
flutter test

# Generar código (freezed + riverpod)
dart run build_runner build --delete-conflicting-outputs

# Limpiar build
flutter clean && flutter pub get
```

---

## Flujo de trabajo

- Rama base para features: `develop` (nunca directamente a `main`)
- Nombre de ramas: `feature/XX-descripcion` donde XX es el número de issue
- Commits: Conventional Commits — `feat(player): ...`, `fix(auth): ...`
- PR siempre hacia `develop`, el CI debe pasar antes de hacer merge
- Al terminar una issue: moverla a "Hecho" en el Project de GitHub

---

## Lo que NO hacer

- No hardcodear colores fuera de `core/theme/app_theme.dart`
- No hacer queries a Supabase directamente desde un widget
- No subir el archivo `.env` al repo
- No hacer commit directo a `main` ni a `develop`
- No mezclar más de una issue en un mismo PR
- No usar `setState` para estado que afecte a más de un widget
