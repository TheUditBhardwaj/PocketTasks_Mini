# PocketTasks

**PocketTasks** is a minimal and fast offline task management app built with Flutter.  
It lets you **add**, **search**, **filter** (All/Active/Done), **complete**, **delete**, and **undo** tasks with persistent local storage, clean state management, and a custom progress indicator.

![Screenshot of PocketTasks main UI][1]

## Features

- **Add New Tasks**  
  Quick task entry with empty-title validation and inline error message.

- **Search Tasks**  
  Debounced (300ms) search box filters tasks by title in real-time.

- **Filter Chips**  
  Toggle between All, Active (not done), and Done tasks.

- **Task List Management**
  - **Tap**: Check/uncheck tasks (with undo via SnackBar).
  - **Swipe**: Delete tasks (with undo).
  - **Undo**: Restore tasks or toggle completion with SnackBar actions.

- **Offline Persistence**  
  All tasks stored locally using `shared_preferences`; data survives app restart.

- **Custom Progress Ring**  
  Circular progress indicator accurately reflects #done/#total with CustomPainter.

- **Efficient with Large Lists**  
  Uses `ListView.builder`, optimized for 100+ tasks.

- **Themes**  
  Supports both Light & Dark Mode.

- **Well-structured State Management**  
  Uses `ChangeNotifier` for minimal and clear reactive state.

- **Unit-tested Search & Filter Logic**  
  Ensures code correctness and query/filter reliability.

## Getting Started

### 1. Clone the repository

```sh
git clone https://github.com/YOUR_GITHUB_USERNAME/pocket_tasks.git
cd pocket_tasks
```

### 2. Install dependencies

```sh
flutter pub get
```

### 3. Run the app

```sh
flutter run
```

### 4. Run tests

```sh
flutter test
```

## Folder Structure

```
lib/
  main.dart
  models/
    task.dart
  providers/
    task_provider.dart
  services/
    storage_service.dart
  screens/
    home_screen.dart
  widgets/
    progress_ring.dart
test/
  task_provider_test.dart
```

## Architecture & Design

- **State Management**: `ChangeNotifier` (easy to refactor for Riverpod if desired).
- **Persistence**: All tasks serialized as JSON in `shared_preferences` under the key `pocket_tasks_v1`.
- **Undo**: All destructive actions (toggle, delete) surface a SnackBar with "Undo".
- **Custom Painter**: Circular progress ring is built for accuracy in both light and dark themes.
- **Tests**: Covers search and filter logic over all edge cases.

## Dependencies

- [provider](https://pub.dev/packages/provider)
- [shared_preferences](https://pub.dev/packages/shared_preferences)
- [uuid](https://pub.dev/packages/uuid)


## Screenshots
<img width="385" height="787" alt="image" src="https://github.com/user-attachments/assets/ab91e455-028d-4c6b-ad04-bed678b5ca5b" />
<img width="385" height="787" alt="image" src="https://github.com/user-attachments/assets/b54be00e-c5c3-4c0c-8a91-a8e5506c6e04" />


