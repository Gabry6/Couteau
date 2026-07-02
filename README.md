# ITLA Toolbox App

App Flutter multi-función para la tarea de Desarrollo de Aplicaciones Móviles (ITLA).

## Vistas incluidas
1. Home con foto de caja de herramientas y menú.
2. Predicción de género (genderize.io) — azul si masculino, rosa si femenino.
3. Predicción de edad (agify.io) — joven / adulto / anciano con ícono y edad.
4. Universidades por país (adamix.net proxy — Hipolabs University API).
5. Clima en Santo Domingo, RD (Open-Meteo, sin API key).
6. Pokédex (PokeAPI): foto, experiencia base, habilidades y sonido (cry).
7. Últimas 3 noticias de un sitio WordPress (wptavern.com vía REST API) con link "Visitar".
8. Acerca de: tu foto y datos de contacto.

## Pasos para dejarla lista para entregar

### 1. Instalar dependencias
```bash
flutter pub get
```

### 2. Personalizar tus datos
Ya está hecho: `lib/screens/about_screen.dart` tiene tus datos (Carlos Gabriel Thomas C.,
matrícula 2023-1296, correo institucional, teléfono) y tu foto ya está en
`assets/icon/icon.png` (recortada a 1024x1024).

### 3. Generar el ícono de la app (tu foto)
```bash
flutter pub run flutter_launcher_icons
```

### 4. Probar la app
```bash
flutter run
```

### 5. Compilar el APK
```bash
flutter build apk --release
```
El APK queda en `build/app/outputs/flutter-apk/app-release.apk`.

### 6. Subir el código a GitHub
```bash
git init
git add .
git commit -m "ITLA Toolbox App - entrega final"
git branch -M main
git remote add origin https://github.com/Gabry6/Couteau.git
git push -u origin main
```

### 7. Publicar el APK
Sube el APK a GitHub Releases (Releases > Draft a new release > adjunta el .apk)
o a un servicio como Google Drive / Firebase App Distribution, y copia la URL pública.

### 8. Publicar el API de WordPress usado en el foro
Este proyecto usa `https://wptavern.com/wp-json/wp/v2/posts?per_page=3&_embed`
(definido en `lib/screens/wordpress_news_screen.dart`, constante `kWordpressSite`).
Publica esa URL en el foro:
https://aulavirtual.itla.edu.do/mod/forum/view.php?id=101978

### 9. PDF final de entrega
Debe incluir: matrícula, nombre, apellido, foto, URL al código (GitHub),
URL al APK, y un código QR que apunte al APK.
Una vez tengas la URL real del repo y del APK, puedo generarte ese PDF —
solo compárteme: nombre completo, matrícula (ya la tengo: 2023-1296),
tu foto, la URL del repo y la URL del APK.

## Estructura del proyecto
```
lib/
  main.dart
  services/api_service.dart
  screens/
    gender_screen.dart
    age_screen.dart
    universities_screen.dart
    weather_screen.dart
    pokemon_screen.dart
    wordpress_news_screen.dart
    about_screen.dart
assets/icon/icon.png   <- tu foto va aquí
```
