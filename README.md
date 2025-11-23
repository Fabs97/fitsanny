# FitSanny 🧚‍♀️

![FitSanny Logo](./assets/launcher/icon.png)

**FitSanny** is your personal "fit fairy" tracker, designed to help you manage your workouts, track your goals, and keep a history of your fitness journey. Built with Flutter, it focuses on a clean user experience and local data privacy.

## ✨ Features

- **Workout Tracking**: Create and manage your training routines.
- **Exercise Library**: Maintain a database of exercises with custom names.
- **Goal Setting**: Set and track your fitness goals.
- **Progress Logging**: Keep a detailed history of your workouts and logs.
- **Data Management**:
  - Local database storage using SQFlite.
  - Backup and Restore functionality to keep your data safe.
  - Export data to external storage.
- **Localization**: Support for multiple languages (English, Italian, etc.).
- **Dark/Light Mode**: Customizable theme settings.

## 🛠 Tech Stack

This project is built using **Flutter** and leverages a robust set of packages for state management, navigation, and data handling:

- **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- **Navigation**: [go_router](https://pub.dev/packages/go_router)
- **Database**: [sqflite](https://pub.dev/packages/sqflite)
- **Forms**: [flutter_form_builder](https://pub.dev/packages/flutter_form_builder) & [form_builder_validators](https://pub.dev/packages/form_builder_validators)
- **Localization**: [intl](https://pub.dev/packages/intl)
- **Utilities**:
  - [equatable](https://pub.dev/packages/equatable) for value equality.
  - [uuid](https://pub.dev/packages/uuid) for unique identifiers.
  - [shared_preferences](https://pub.dev/packages/shared_preferences) for simple key-value storage.
  - [file_picker](https://pub.dev/packages/file_picker) & [permission_handler](https://pub.dev/packages/permission_handler) for file operations.

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.9.2 or higher)
- Android Studio or VS Code with Flutter extensions
- An Android/iOS emulator or physical device

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/yourusername/fitsanny.git
    cd fitsanny
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run the app:**
    ```bash
    flutter run
    ```

### Code Generation

This project uses code generation for localization and other tasks. If you make changes to localized strings or other generated files, run:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```
*(Note: Adjust command based on specific generators used, e.g., for `intl` it might be `flutter gen-l10n` if configured in `l10n.yaml`)*

## 📂 Project Structure

- `lib/bloc`: Contains Business Logic Components (Cubits/Blocs).
- `lib/pages`: UI screens and pages.
- `lib/model`: Data models.
- `lib/repositories`: Data access layer.
- `lib/l10n`: Localization files.
- `lib/utils`: Helper functions and constants.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
