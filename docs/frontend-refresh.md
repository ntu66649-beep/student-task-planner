# Frontend refresh

The `feature/frontend-refresh` branch builds on `feature/integration` (the branch with the combined login and task flows).

## Interface

- Shared Studyflow visual theme: warm neutral surfaces, teal accents, clear typography and rounded task cards.
- Responsive login with a desktop introduction panel and a compact mobile layout.
- Dashboard with live pending/completed counts, progress and upcoming tasks. Counts refresh after returning from the task list.
- Search titles and descriptions, combine search with All/Pending/Completed filters, and show contextual empty states.
- Deadline-ordered cards with priority badges, overdue labels, completion controls and delete confirmation.
- Scrollable task form with a fixed Save Task action. Required title/deadline validation and duplicate-save protection remain in place.
- Existing routes, task model, demo credentials, widget keys and task action accessibility labels are retained.

## Run

```sh
flutter pub get
flutter run
```

Demo credentials: `student` / `123456`.

## Validation

```sh
flutter analyze
flutter test
flutter build web --no-wasm-dry-run
```

Widget coverage includes the existing add/validation cases, search + status filtering, confirmation/cancellation of deletion, login → task completion → dashboard refresh → logout, and layouts at widths 320, 390 and 1280 with 130% text size. Chrome smoke testing also covers login and creating a task through the date picker.

Tasks still use the existing in-memory store: they survive screen navigation, but are cleared on application restart. Authentication is still the project's demo login. No backend or persistent storage is introduced. Android/Appium device tests must be run with a connected emulator/device; browser and widget checks do not replace them.
