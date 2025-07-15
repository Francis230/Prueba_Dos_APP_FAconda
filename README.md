Claro, aquí tienes el contenido adaptado para que lo copies y pegues directamente en tu archivo `README.md` de GitHub con formato Markdown correcto:

---

````markdown
# 🏢 Aplicación de Registro de Visitantes - `pruebados_fa_supa`

![Login](https://placehold.co/600x400/000/FFF?text=Pantalla+de+Login)
![Home](https://placehold.co/600x400/000/FFF?text=Pantalla+Principal)
![Agregar Visitante](https://placehold.co/600x400/000/FFF?text=Pantalla+Agregar+Visitante)

Una aplicación móvil desarrollada con **Flutter** para la gestión eficiente del registro de visitantes en una oficina.  
Permite a los usuarios autenticarse, registrar nuevos visitantes con detalles como nombre, motivo, hora y una foto, y visualizar una lista actualizada en tiempo real de todos los registros.

---

## ✨ Características

### 🔐 Autenticación Segura
- Registro e inicio de sesión con correo electrónico y contraseña.
- Gestión de sesiones de usuario.

### 🧾 Gestión de Visitantes
- Lista en tiempo real de visitantes registrados (nombre, motivo, hora).
- Formulario para agregar nuevos visitantes.
- Captura de foto con cámara o galería.
- Selección de fecha y hora.

### 🎯 Experiencia de Usuario Optimizada
- Indicadores visuales de carga.
- Notificaciones de éxito y error con `fluttertoast`.
- Manejo de permisos de cámara y almacenamiento.
- Diseño moderno con paleta de colores personalizada (negro, azul, amarillo, rojo).

### 🧩 Backend Robusto
- Autenticación con Supabase Auth.
- Base de datos PostgreSQL con Supabase Database.
- Almacenamiento de imágenes con Supabase Storage.
- Actualización en tiempo real usando `stream()`.

---

## 🛠️ Tecnologías Utilizadas

- **Flutter** – Framework de UI.
- **Dart** – Lenguaje de programación.
- **Supabase** – Backend (auth + database + storage).
- `supabase_flutter` – Integración Supabase + Flutter.
- `Provider` – Gestión de estado.
- `Image Picker` – Captura y selección de imágenes.
- `Permission Handler` – Manejo de permisos.
- `Intl` – Formateo de fecha/hora.
- `Fluttertoast` – Notificaciones en pantalla.

---

## 🚀 Configuración del Proyecto

### 1. Clonar el Repositorio

```bash
git clone https://github.com/tu-usuario/pruebados_fa_supa.git
cd pruebados_fa_supa
````

### 2. Instalación de Dependencias

```bash
flutter pub get
```

---

### 3. Configuración de Supabase

#### a. Crear Proyecto Supabase

1. Ir a [https://supabase.com](https://supabase.com)
2. Crear un nuevo proyecto.

#### b. Obtener Credenciales

Ve a: **Project Settings > API**
Copia:

* `Project URL`
* `Anon Key`

#### c. Agregar Credenciales en Flutter

Edita: `lib/config/supabase_config.dart`

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'TU_URL_DE_SUPABASE_AQUÍ';
  static const String supabaseAnonKey = 'TU_CLAVE_ANON_DE_SUPABASE_AQUÍ';
}
```

---

### 4. Configurar Base de Datos

#### Crear tabla `visitors`:

```sql
create table public.visitors (
  id uuid not null default gen_random_uuid (),
  name text not null,
  reason text not null,
  visit_time timestamp with time zone not null default now(),
  photo_url text null,
  constraint visitors_pkey primary key (id)
);
```

#### Activar Row Level Security (RLS) y agregar políticas:

* **SELECT:**

  * Name: `Enable read access for authenticated users`
  * Roles: `authenticated`
  * Using: `true`

* **INSERT:**

  * Name: `Enable insert access for authenticated users`
  * Roles: `authenticated`
  * With check: `true`

---

### 5. Configurar Supabase Storage (Bucket)

#### Crear Bucket

* Nombre: `visitor_photos`

#### Políticas de Seguridad (RLS)

* **INSERT:**

```sql
create policy "Allow authenticated uploads for visitor photos"
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'visitor_photos' AND auth.uid() IS NOT NULL
);
```

* **SELECT:**

```sql
create policy "Allow authenticated downloads for visitor photos"
on storage.objects
for select
to authenticated
using (
  bucket_id = 'visitor_photos'
);
```

---

### 6. Permisos en Android (`AndroidManifest.xml`)

Agrega dentro de `<manifest>` (fuera de `<application>`):

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
<uses-permission android:name="android.permission.READ_MEDIA_AUDIO" />
```

---

### 7. Ejecutar la Aplicación

```bash
flutter run
```

Para generar APK de producción:

```bash
flutter clean
flutter build apk --release
```

---

## 📂 Estructura del Proyecto

```
pruebados_fa_supa/
├── lib/
│   ├── config/             # Configuración (URL/Key Supabase)
│   ├── models/             # Modelo de datos (Visitor)
│   ├── screens/
│   │   ├── auth/           # Login y registro
│   │   ├── home/           # Agregar visitante, pantalla principal
│   │   └── splash_screen.dart
│   ├── services/           # Supabase Auth y lógica de visitantes
│   ├── widgets/            # Componentes reutilizables
│   └── main.dart           # Punto de entrada
├── android/
├── ios/
├── pubspec.yaml
└── README.md
```

---

## 💡 Uso de la Aplicación

1. **Login/Register**: Inicia sesión o regístrate.
2. **Pantalla Principal**: Lista en tiempo real de visitantes.
3. **Agregar Visitante**: Completa nombre, motivo, hora y foto.
4. **Guardar**: El visitante se registra en Supabase.
5. **Cerrar sesión**: Desde la AppBar.

---

## 🐛 Solución de Problemas

| Problema                                  | Solución                                                                                                                                  |
| ----------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| `Could not find the correct Provider`     | Verifica que `MultiProvider` esté bien configurado en `main.dart`. Usa `flutter clean && flutter run`.                                    |
| `StorageException(...) violates RLS`      | Verifica las políticas RLS del bucket `visitor_photos`. Deben existir políticas INSERT y SELECT para el rol `authenticated`.              |
| Permisos de cámara o almacenamiento       | Verifica `AndroidManifest.xml`. En algunos dispositivos Android 13+ deberás conceder permisos manualmente desde "Ajustes > Aplicaciones". |
| Gradle `Unresolved reference: Properties` | Agrega `import java.util.Properties` y `import java.io.FileInputStream` al inicio de `android/app/build.gradle.kts`.                      |

---

## 👨‍💻 Desarrollador

Proyecto desarrollado por **Francis Aconda**.


```

---

¿Quieres que también te genere una versión en inglés o que lo suba en un archivo `.md` para que lo descargues?
```

