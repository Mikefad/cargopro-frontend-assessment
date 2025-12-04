# CargoPro Assignment

Cross‑platform Flutter (mobile + web) app for CargoPro’s Frontend Internship assessment. It combines Firebase phone‑number authentication, GetX architecture, and full CRUD against the public `https://api.restful-api.dev/objects` endpoint. The UI is responsive, Material‑themed, and tuned for both touch and desktop form factors.

## Live Links & Assets

> Replace the placeholders with your actual links before submission.

| Artifact | Link |
| --- | --- |
| Web (Firebase Hosting) | https://cargopro-assignment.web.app/ |
| Android APK (Drive) | https://drive.google.com/file/d/1FoZPb7y_9y6JH5A27FEJHS_MYc9qTgsf/view?usp=sharing |
| Walkthrough video (Drive) | https://drive.google.com/file/d/1XaI4PzyvoTONfI8upbkogZFWk-vuNH4x/view?usp=sharing |

## Tech Stack

- Flutter 3.19+
- GetX (state, DI, navigation)
- Firebase Auth (phone OTP on mobile & web)
- REST API via `package:http`
- Google Fonts + custom theming

## Features

- Phone‑number OTP login with Firebase for both mobile and web.
- Full CRUD on the RESTful Objects API (GET list/detail, POST, PUT, DELETE).
- Paginated dashboard with optimistic UI updates and pull‑to‑refresh.
- Compose JSON editor with validation + friendly error snackbars.
- Responsive layout + Material 3 theme with “wow” gradient shell.

## Project Structure

```
lib/
 ├─ app/              # routes, bindings, theme
 ├─ controllers/      # GetX controllers (auth, objects)
 ├─ services/         # REST client abstraction
 ├─ models/           # CargoObject data class
 ├─ utils/            # validation helpers
 └─ views/            # UI (auth screens, objects list/detail/form)
test/
 ├─ api_service_test.dart
 └─ object_controller_test.dart
```

## Firebase Setup (mobile + web)

1. Create a Firebase project.
2. Enable **Phone Authentication** in `Authentication → Sign-in method`.
3. Register your apps:
   - Android: add package name, download `google-services.json` into `android/app`.
   - iOS (optional): add bundle ID, download `GoogleService-Info.plist`.
   - Web: add web app, copy config.
4. Run `dart pub global activate flutterfire_cli` once, then execute:
   ```bash
   flutterfire configure
   ```
   This regenerates `lib/firebase_options.dart` with your keys (the repo currently contains a placeholder—do not commit secrets).
5. For web testing on localhost, add `localhost` to `Authentication → Settings → Authorized domains`.

## Environment & Tooling

```
Flutter 3.19+
Dart 3.3+
Chrome / Android SDK 34+
```

Install dependencies:
```bash
flutter pub get
```

## Running

### Web
```bash
flutter run -d chrome
```

### Android
```bash
flutter run -d <device-id>
```

Hot reload (`r`) and restart (`R`) work as usual.

## Testing

Two unit tests cover an API call and a controller function (per assignment):
```bash
flutter test
```

Files:
- `test/api_service_test.dart`
- `test/object_controller_test.dart`

## Deployment

### Firebase Hosting (web)
```bash
flutter build web --release
firebase login
firebase init hosting   # select existing project, set public dir to build/web, enable SPA rewrite
firebase deploy --only hosting
```
Record the hosting URL and place it in the table above + README.

### Android APK/AAB
```bash
flutter build apk --release   # or flutter build appbundle
```
Upload `build/app/outputs/flutter-apk/app-release.apk` (or AAB) to Google Drive, make it public, and paste the link above.

## Creating the Walkthrough Video

1. Record ~7 minutes covering:
   - Auth flow (web + mobile emulator).
   - Folder structure & GetX bindings.
   - CRUD demo (list, detail, create, PUT, delete with optimistic UI and pagination).
   - Error handling (e.g., invalid JSON, offline state).
   - Deployment summary (show Firebase Hosting URL + APK location).
2. Upload the video to Drive, set sharing to “Anyone with the link”.
3. Update the table at the top of this README.

## Design Notes

- **Navigation & DI:** `AppBindings` wires AuthController/ObjectController/ApiService through GetX once.
- **Theme:** Custom gradient background, Google Fonts, card + chip styling, consistent spacing for mobile/web.
- **Error Handling:** Every API call catches exceptions, updates controller state, and (when UI context exists) surfaces `Get.snackbar` messages.
- **Optimistic updates:** Deletes remove items immediately with rollback on failure; creates insert at the top of the list.
- **Pagination:** “Load more” fetches additional pages from the public API; controller tracks `hasMore` & `isMoreLoading`.

## Limitations / Future Work

- REST API is public/read-only for shared data: newly created objects exist only within your session and won’t appear in subsequent `fetchObjects` calls. The app keeps locally created items in memory; for a production backend you’d persist them server-side.
- No offline cache/local persistence.
- iOS build/TestFlight not configured.

## Submission Checklist

1. Update all placeholder links (web deploy, APK, video).
2. Push to a public GitHub repository.
3. Email `careers@cargopro.ai` with subject `YourName_FrontendDevelopment_Internship`, include repo link + resume + asset links.

Good luck!
