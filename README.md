# WooFriend — App móvil (Flutter)

Aplicación móvil de **WooFriend**, una plataforma de adopción de mascotas. Permite a los usuarios registrarse, explorar animales en adopción, enviar formularios de adopción, realizar publicaciones y subir imágenes desde el dispositivo.

Proyecto desarrollado como trabajo de grado del Tecnólogo en Desarrollo de Software (SENA). Consume la API REST del backend de WoofFriend (NestJS + PostgreSQL).

**Autor:** Kevin Lievano · lvrd07@gmail.com

---

## Tecnologías

- **Flutter / Dart**
- **Riverpod** para la gestión de estado
- **Go Router** para la navegación
- **Dio / http** para el consumo de la API REST
- **Formz** para la validación de formularios
- **image_picker** para la selección y carga de imágenes
- **shared_preferences** para almacenamiento local (sesión / token)
- **Google Fonts** y **flutter_svg** para la interfaz

## Funcionalidades

- Registro e inicio de sesión de usuarios.
- Exploración de animales disponibles para adopción.
- Envío de formularios de adopción.
- Publicaciones y carga de imágenes.

## Requisitos previos

- Flutter SDK (Dart 3.1+)
- El backend de WoofFriend corriendo (local o desplegado)

## Cómo ejecutarlo

```bash
# 1. Instalar dependencias
flutter pub get

# 2. Crear el archivo .env con la URL de la API
cp .env.example .env

# 3. Ejecutar la app (con un emulador o dispositivo conectado)
flutter run
```

## Variables de entorno (.env)

```
API_URL=http://localhost:3000
```

> Nota: el archivo `.env` no debe subirse al repositorio. Usa `.env.example` como plantilla.
