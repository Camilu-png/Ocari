# Ocari 🎵

> Aprende a tocar la ocarina de 12 hoyos de forma visual y sencilla.

Ocari es una aplicación móvil diseñada para músicos y entusiastas que desean dominar la ocarina de 12 hoyos. A través de una interfaz intuitiva, la app muestra las posiciones exactas de los dedos en tiempo real para cada nota de tus canciones favoritas — inspirada en la experiencia de Simply Piano, adaptada al mundo de la ocarina.

---

## Características principales

- **Guía visual en tiempo real** — Visualización interactiva de la posición de los dedos para ocarinas de 12 hoyos, fiel al estilo de digitación estándar.
- **Biblioteca de canciones** — Incluye temas icónicos de videojuegos, anime y música clásica.
- **Control de velocidad** — Ajusta el tempo de reproducción para practicar a tu propio ritmo (×0.5, ×0.75, ×1).
- **Modo próximas notas** — Anticipa los cambios de posición con una línea de tiempo de notas futuras.
- **Progreso personal** — Historial de canciones practicadas y estadísticas de sesión.

---

## Stack tecnológico

| Capa           | Tecnología     |
| -------------- | -------------- |
| Mobile         | Flutter (Dart) |
| Estado         | Riverpod       |
| Navegación     | go_router      |
| Backend / Auth | Supabase       |
| Audio          | just_audio     |
| CI/CD          | GitHub Actions |

---

## Estructura del proyecto

```
lib/
├── core/
│   ├── theme/          # AppTheme, AppColors, AppTextStyles
│   ├── router/         # go_router — rutas y redirects
│   └── widgets/        # Componentes reutilizables
├── features/
│   ├── auth/           # Login, registro, sesión
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── songs/          # Lista y detalle de canciones
│   └── player/         # Reproductor + ocarina animada
└── main.dart
```

---

## Cómo correr el proyecto localmente

### Requisitos previos

- Flutter SDK `>=3.18.0`
- Dart `>=3.8.1 <4.0.0`
- Una cuenta en [Supabase](https://supabase.com) (free tier)

### Instalación

```bash
# 1. Clonar el repositorio
git clone https://github.com/tu-usuario/ocari.git
cd ocari

# 2. Instalar dependencias
flutter pub get

# 3. Configurar variables de entorno
cp .env.example .env
# Editar .env con tus credenciales de Supabase

# 4. Correr la app
flutter run --dart-define-from-file=.env
```

### Variables de entorno

Crea un archivo `.env` en la raíz del proyecto (nunca lo subas al repo):

```env
SUPABASE_URL=https://tu-proyecto.supabase.co
SUPABASE_ANON_KEY=tu-anon-key
```

---

## Flujo de desarrollo

Este proyecto usa la siguiente estrategia de branching:

```
main        ← producción (solo merge desde develop via PR)
develop     ← integración (rama base para features)
feature/*   ← una rama por issue
```

### Convención de commits

Seguimos [Conventional Commits](https://www.conventionalcommits.org/):

```
feat(player): add hole animation for D4 note
fix(auth): fix redirect on logout
chore(ci): update Flutter version in GitHub Actions
docs(readme): add installation instructions
```

### Crear una rama de feature

```bash
git checkout develop
git pull origin develop
git checkout -b feature/07-login-email
```

---

## Hoja de ruta

### Sprint 0 — Fundación _(en progreso)_

- [x] Aplicación base Flutter inicializada
- [ ] Estructura de carpetas y arquitectura
- [ ] Configuración de Supabase
- [ ] Navegación base con go_router
- [ ] Auth (login, registro, Google Sign-In)
- [ ] Design system y componentes base
- [ ] CI/CD con GitHub Actions

### Sprint 1 — Reproductor _(próximo)_

- [ ] Pantalla de lista de canciones
- [ ] Reproductor con ocarina animada (CustomPainter)
- [ ] Sincronización audio → nota → digitación
- [ ] Control de velocidad de reproducción

### Sprint 2 — Pulido y lanzamiento

- [ ] Modelo freemium (canciones gratuitas / premium)
- [ ] Progreso y estadísticas del usuario
- [ ] Preparación para App Store y Google Play

---

## Licencia

MIT © 2025 — Ocari
