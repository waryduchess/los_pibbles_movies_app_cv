# Widgets - Estructura Organizada

Carpeta de widgets de Flutter organizados por funcionalidad y componente.

## 📁 Estructura de Carpetas

```
widgets/
├── auth/                          # Widgets de autenticación
│   └── forgot_password/           # Flujo de recuperación de contraseña
│       ├── email_step.dart
│       ├── new_password_step.dart
│       └── success_step.dart
│
├── buttons/                       # Componentes de botones
│   ├── animated_favorite_button.dart
│   ├── back_button_widget.dart
│   ├── biometric_auth_button.dart
│   ├── button_widget.dart
│   └── logout_button_widget.dart
│
├── cards/                         # Tarjetas de contenido
│   ├── cr_message_card.dart
│   ├── movie_actor_card.dart
│   ├── movie_review_card.dart
│   └── validation_card_widget.dart
│
├── chips/                         # Tags y chips seleccionables
│   ├── tag_chip.dart
│   └── tag_chip2.dart
│
├── comments/                      # Secciones de comentarios
│   ├── add_comment_sheet.dart
│   ├── comment_section.dart
│   └── home_comments_section.dart
│
├── common/                        # Componentes comunes reutilizables
│   ├── cr_button.dart
│   ├── cr_error_state.dart
│   └── cr_section_header.dart
│
├── dialogs/                       # Diálogos modales
│   ├── logout_dialog.dart
│   └── show_logout_dialog.dart
│
├── inputs/                        # Campos de entrada
│   ├── cr_radio_card.dart
│   ├── cr_search_field.dart
│   └── cr_text_field.dart
│
├── movies/                        # Widgets relacionados con películas
│   ├── cr_category_chip.dart
│   ├── featured_movie_card.dart
│   ├── featured_movie_carousel.dart
│   ├── movie_card_item.dart
│   ├── movie_comments_section.dart
│   ├── movie_reviews_section.dart
│   └── movie_tech_info.dart
│
├── settings/                      # Widgets de configuración
│   ├── biometric_card_widget.dart
│   ├── cr_faq_item.dart
│   ├── menu_card_widget.dart
│   ├── profile_card_widget.dart
│   ├── profile_photo_widget.dart
│   └── section_label_widget.dart
│
├── ui_elements/                   # Elementos UI genéricos
│   ├── category_selector.dart
│   ├── gradient_background_widget.dart
│   ├── input_widget.dart
│   ├── search_bar_widget.dart
│   └── text_widget.dart
│
├── index.dart                     # Archivo índice principal
└── README.md                      # Este archivo
```

## 📊 Resumen

| Carpeta | Cantidad | Descripción |
|---------|----------|-------------|
| auth | 3 | Autenticación y recuperación de contraseña |
| buttons | 5 | Botones especializados |
| cards | 4 | Tarjetas de contenido |
| chips | 2 | Tags y chips seleccionables |
| comments | 3 | Sistema de comentarios |
| common | 3 | Componentes comunes reutilizables |
| dialogs | 2 | Diálogos modales |
| inputs | 3 | Campos de entrada de usuario |
| movies | 7 | Widgets específicos para películas |
| settings | 6 | Pantalla de configuración |
| ui_elements | 5 | Elementos básicos de UI |
| **Total** | **53** | **Archivos Dart** |

## 🎯 Categorías por Función

### Autenticación
- `auth/` - Flujos de login y recuperación

### Interfaz de Usuario
- `buttons/` - Botones
- `cards/` - Tarjetas
- `chips/` - Tags
- `ui_elements/` - Elementos básicos

### Entrada de Datos
- `inputs/` - Campos de formulario
- `ui_elements/search_bar_widget.dart` - Búsqueda

### Contenido
- `movies/` - Todo lo relacionado con películas
- `comments/` - Sistema de comentarios
- `cards/` - Tarjetas de información

### Configuración
- `settings/` - Pantalla de ajustes
- `dialogs/` - Diálogos modales

### Componentes Base
- `common/` - Reutilizables en todo el proyecto

## 💡 Notas

- El archivo `index.dart` importa y exporta todos los widgets principales
- Los prefijos `cr_` indican widgets personalizados del proyecto
- Cada carpeta contiene widgets temáticamente relacionados
- La estructura facilita la navegación y mantenimiento del código
