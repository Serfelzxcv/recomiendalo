# Recomiendalo

Aplicación Flutter enfocada en conectar personas que necesitan un servicio con profesionales/oficios disponibles.

## Objetivo del proyecto

`Recomiendalo` funciona como un marketplace de servicios locales:

- Un usuario en modo **Empleador** publica trabajos y busca colaboradores.
- Un usuario en modo **Colaborador** gestiona su perfil y sus ofertas.

La app permite alternar entre ambos modos desde la interfaz.

## Roles y flujo principal

### Modo Empleador

- Publicar trabajo (flujo por pasos).
- Ver trabajos publicados.
- Ver referencias como empleador.
- Buscar y conectar con trabajadores.

### Modo Colaborador

- Ver/gestionar perfil profesional.
- Ver ofertas recibidas.
- Sección de trabajos en curso (pendiente/próximamente).

## Estado actual

Proyecto en etapa **MVP**:

- UI y navegación principal implementadas.
- Cambio de modo de usuario integrado con Riverpod.
- Parte de los datos están mockeados/hardcodeados (jobs, referencias, perfiles).
- Base de integración con backend ya iniciada (auth con `Dio`).

## Stack técnico

- Flutter (Material 3)
- Riverpod (estado global)
- GoRouter (navegación)
- Dio (HTTP)
- flutter_dotenv (variables de entorno)

## Estructura general

- `lib/features/auth`: login, registro y servicios de autenticación.
- `lib/features/home`: home dinámico por modo de usuario.
- `lib/features/jobs`: creación/listado/detalle de trabajos.
- `lib/features/profiles`: perfiles del colaborador.
- `lib/features/references`: referencias/reseñas.
- `lib/features/connect`: búsqueda y conexión con profesionales.
- `lib/shared`: widgets y providers compartidos.
- `lib/core`: router, tema, red y constantes.

## Ejecución local

1. Instalar dependencias:

```bash
flutter pub get
```

2. Verificar `.env` (si aplica para tus servicios).

3. Ejecutar:

```bash
flutter run
```

## Notas

- El `baseUrl` actual de red se define en `lib/core/network/dio_client.dart`.
- Algunas rutas/funciones están en progreso y pueden mostrar contenido de ejemplo.
