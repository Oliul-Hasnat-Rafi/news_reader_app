# Project structure



## Folder Structure

```
📦lib
 ┣ 📂assets
 ┣ 📂src
 ┃ ┣ 📂controllers
 ┃ ┃ ┣ 📂data_controllers
 ┃ ┃ ┃ ┣ 📜app_data_controller.dart
 ┃ ┃ ┃ ┗ 📜auth_controller.dart
 ┃ ┃ ┗ 📂screen_controllers
 ┃ ┃ ┃ ┣ 📂authentication
 ┃ ┃ ┃ ┃ ┣ 📜controller.dart
 ┃ ┃ ┃ ┃ ┣ 📜repository.dart
 ┃ ┃ ┃ ┃ ┗ 📜use_case.dart
 ┃ ┃ ┃ ┗ 📂splash_screen
 ┃ ┃ ┃   ┗ 📜controller.dart
 ┃ ┣ 📂core
 ┃ ┃ ┣ 📂environment
 ┃ ┃ ┃ ┗ 📜environment.dart
 ┃ ┃ ┣ 📂http
 ┃ ┃ ┃ ┣ 📜http_client.dart
 ┃ ┃ ┃ ┣ 📜http_error_enum.dart
 ┃ ┃ ┃ ┣ 📜http_error_handler.dart
 ┃ ┃ ┃ ┗ 📜http_repository.dart
 ┃ ┃ ┣ 📂localization
 ┃ ┃ ┃ ┣ 📜app_translations.dart
 ┃ ┃ ┃ ┗ 📜string_enum.dart
 ┃ ┃ ┣ 📂theme
 ┃ ┃ ┃ ┣ 📜app_theme.dart
 ┃ ┃ ┃ ┣ 📜colors.dart
 ┃ ┃ ┃ ┗ 📜text_styles.dart
 ┃ ┃ ┗ 📂use_case
 ┃ ┃   ┗ 📜use_case.dart
 ┃ ┣ 📂models
 ┃ ┃ ┗ 📂data
 ┃ ┃ ┃ ┣ 📂api_models
 ┃ ┃ ┃ ┗ 📂app_models
 ┃ ┃ ┃   ┗ 📜user_model.dart
 ┃ ┣ 📂utils
 ┃ ┃ ┣ 📂dev_functions
 ┃ ┃ ┃ ┣ 📜dev_auto_fill_button.dart
 ┃ ┃ ┃ ┣ 📜dev_button.dart
 ┃ ┃ ┃ ┣ 📜dev_print.dart
 ┃ ┃ ┃ ┗ 📜dev_scaffold.dart
 ┃ ┃ ┣ 📂functions
 ┃ ┃ ┃ ┣ 📜form_validation.dart
 ┃ ┃ ┃ ┗ 📜string_conversion.dart
 ┃ ┃ ┗ 📂user_message
 ┃ ┃   ┗ 📜snackbar.dart
 ┃ ┗ 📂views
 ┃   ┣ 📂screens
 ┃   ┗ 📂widgets
 ┣ 📜components.dart
 ┗ 📜main.dart
```

This is a detailed folder structure. In short, we may focus on the simplified structure shown below:

```
📦lib
 ┣ 📂assets
 ┣ 📂src
 ┃ ┣ 📂controllers
 ┃ ┃ ┣ 📂data_controllers // ----------------------------- App Data Will be here
 ┃ ┃ ┃ ┣ 📜app_data_controller.dart
 ┃ ┃ ┃ ┗ 📜auth_controller.dart
 ┃ ┃ ┗ 📂screen_controllers // ------------- Screen functionalities will be here
 ┃ ┣ 📂core
 ┃ ┃ ┣ 📂environment // --------------------------------------- Handle .ENV file
 ┃ ┃ ┣ 📂http // ----------------------------------------------- Handle API call
 ┃ ┃ ┣ 📂localization // ----------------------------------- Handle App Language
 ┃ ┃ ┣ 📂theme // --------------------------------------------- Handle App theme
 ┃ ┃ ┗ 📂use_case // -- Abstract class, Handles USE CASE from Clean Architecture
 ┃ ┣ 📂models
 ┃ ┃ ┗ 📂data // ----------------------------- App Models and Enums will be here
 ┃ ┃   ┣ 📂api_models
 ┃ ┃   ┗ 📂app_models
 ┃ ┣ 📂utils // ------------------------ App Utils (Form validation, Print, ...)
 ┃ ┗ 📂views // --------------------------------------------------------- App UI
 ┃   ┣ 📂screens
 ┃   ┗ 📂widgets
 ┣ 📜components.dart // -------------------------- App Components (Default Size)
 ┗ 📜main.dart
```

## MVC Responsibilities

| Layer          | Description                                        |
| -------------- | -------------------------------------------------- |
| **Model**      | App & API models, used across the app              |
| **View**       | Screens and widgets rendered on the UI             |
| **Controller** | Logic layer using GetX, handles state & UI actions |

## Clean Architecture Additions

- `use_case/`: Abstract actions representing app-specific business logic
- `repository.dart`: Optional repository interface per feature for scalability
- `http_repository.dart`: Base HTTP handler using dependency inversion

