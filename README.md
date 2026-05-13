# 🎮 Kids Quiz Game — Flutter E-Learning App

A fun, interactive quiz game for children aged **3–5 years**, built with Flutter. Kids are shown a question and must pick the correct answer from 4 options. The app covers 6 learning categories with 10 questions each, complete with animations, sound effects, confetti, and a star-based scoring system.

---

## 📋 Table of Contents

1. [Features](#features)
2. [App Flow & Screens](#app-flow--screens)
3. [Project Structure](#project-structure)
4. [Core Files Explained](#core-files-explained)
   - [main.dart](#maindart)
   - [Models](#models)
   - [Screens](#screens)
   - [Widgets](#widgets)
   - [Services](#services)
   - [Data](#data)
5. [Quiz Categories & Questions](#quiz-categories--questions)
6. [Assets Guide](#assets-guide)
7. [Dependencies](#dependencies)
8. [Clone the Repository](#clone-the-repository)
9. [Installation & Setup](#installation--setup)
10. [Running on Different Devices](#running-on-different-devices)
11. [Building a Release APK](#building-a-release-apk)
12. [Installing & Running the APK on a Phone](#installing--running-the-apk-on-a-phone)
13. [Customisation Guide](#customisation-guide)

---

## ✨ Features

| Feature | Details |
|---|---|
| 🎨 Kid-Friendly UI | Bright gradients, large rounded buttons, emoji icons |
| 📚 6 Categories | Fruits, Vegetables, Vehicles, Animals, Colors, Shapes |
| ❓ 60 Questions | 10 questions per category, randomly shuffled |
| 🎮 Quiz Gameplay | 4-option multiple choice, 5 questions per session |
| 🎵 Sound System | Background music, correct/wrong/click/celebration sounds |
| ⭐ Star Scoring | 0–3 stars based on percentage correct |
| 🎊 Confetti | Confetti burst animation on every correct answer |
| ⚙️ Settings | Toggle sound effects, background music, and master volume |
| 💾 Persistent Settings | Audio preferences saved with SharedPreferences |
| 📱 Cross-Platform | iOS, Android, and Web |
| 🔄 Animated Transitions | Splash screen, category cards, answer buttons all animated |

---

## 🗺️ App Flow & Screens

```
App Launch
    │
    ▼
Splash Screen          ← Animated logo, auto-navigates after 3 seconds
    │
    ▼
Home Screen            ← "Play!" and "Settings" buttons, bouncing emoji icon
    ├──► Settings Screen   ← Sound effects toggle, music toggle, volume slider, reset
    │
    ▼
Categories Screen      ← 2×3 grid of category cards (Fruits, Vegetables, etc.)
    │
    ▼
Quiz Screen            ← 5 random questions from the selected category
    │                     Image area + question text + 2×2 answer grid
    │                     Correct = green + confetti; Wrong = red highlight
    ▼
Results Screen         ← Score display, 0–3 stars, Play Again / Choose Category / Home
```

---

## 🗂️ Project Structure

```
kids_quiz_game/
├── lib/
│   ├── main.dart                  # App entry point, routes, theme
│   ├── models/
│   │   ├── question.dart          # Question data model
│   │   └── category.dart          # Category data model
│   ├── screens/
│   │   ├── splash_screen.dart     # Animated intro screen
│   │   ├── home_screen.dart       # Main menu (Play + Settings)
│   │   ├── settings_screen.dart   # Audio settings
│   │   ├── categories_screen.dart # Category picker grid
│   │   ├── quiz_screen.dart       # Core quiz gameplay
│   │   └── results_screen.dart    # Score & stars display
│   ├── widgets/
│   │   ├── answer_button.dart     # Animated multiple-choice button
│   │   ├── category_card.dart     # Tappable category card with press animation
│   │   └── quiz_image.dart        # Animated image/placeholder widget
│   ├── services/
│   │   └── audio_service.dart     # Singleton audio manager
│   └── data/
│       └── quiz_data.dart         # All 60 questions across 6 categories
├── assets/
│   ├── images/
│   │   ├── fruits/                # apple.png, banana.png, ... (10 images)
│   │   ├── vegetables/            # carrot.png, tomato.png, ... (10 images)
│   │   ├── vehicles/              # car.png, bus.png, ... (10 images)
│   │   ├── animals/               # lion.png, dog.png, ... (10 images)
│   │   ├── colors/                # red.png, blue.png, ... (10 images)
│   │   └── shapes/                # circle.png, square.png, ... (10 images)
│   └── audio/
│       ├── background_music.mp3   # Looping background track
│       ├── correct.mp3            # Played on correct answer
│       ├── wrong.mp3              # Played on wrong answer
│       ├── click.mp3              # Played on any button tap
│       └── celebration.mp3        # Played on results screen
└── pubspec.yaml
```

---

## 🔍 Core Files Explained

### `main.dart`

The app entry point. Key responsibilities:

- Calls `WidgetsFlutterBinding.ensureInitialized()` so async work (audio init) can happen before `runApp`.
- Initialises `AudioService` as a singleton before the widget tree is built.
- Defines a `MaterialApp` with a named-route table:

| Route | Screen |
|---|---|
| `/` | `SplashScreen` |
| `/home` | `HomeScreen` |
| `/settings` | `SettingsScreen` |
| `/categories` | `CategoriesScreen` |
| `/quiz` | `QuizScreen` |
| `/results` | `ResultsScreen` |

- Uses Material 3 theming with a blue seed colour.
- Also contains `QuizScreenWrapper` (a stateful wrapper that shuffles and limits questions to 5) — currently unused in routing but available for direct widget embedding.

---

### Models

#### `models/question.dart`

```dart
class Question {
  final String imageName;     // Filename (without .png) in assets/images/<category>/
  final String correctAnswer; // The text of the correct option
  final List<String> options; // Exactly 4 answer options (includes the correct one)
}
```

#### `models/category.dart`

```dart
class Category {
  final String name;              // Display name e.g. "Fruits"
  final String icon;              // Emoji icon e.g. "🍎"
  final List<Question> questions; // All questions for this category
}
```

---

### Screens

#### `splash_screen.dart`

- Shows a white circle containing 📚 emoji.
- Runs two `AnimationController`s:
  - **Logo**: scales from 0→1 with `elasticOut` curve, rotates from -0.5→0 rad.
  - **Text**: slides up from below and fades in 800 ms after logo starts.
- After **3000 ms** automatically navigates to `/home` via `pushReplacementNamed`.
- Gradient background: red → yellow.

#### `home_screen.dart`

- Shows a bouncing 🎮 emoji (up-down loop animation via `AnimationController.repeat(reverse: true)`).
- Starts background music on `initState` via `AudioService().playBackgroundMusic()`.
- Two menu buttons: **Play!** (navigates to `/categories`) and **Settings** (navigates to `/settings`).
- Gradient: purple → dark purple.

#### `settings_screen.dart`

- Reads initial values directly from the `AudioService` singleton.
- Three controls:
  - **Sound Effects** toggle — calls `AudioService().setSoundEnabled(value)` and saves to `SharedPreferences`.
  - **Background Music** toggle — calls `AudioService().setMusicEnabled(value)`, which also stops/starts music.
  - **Volume slider** — calls `AudioService().setVolume(value)`, updates both players live.
- **Reset All Settings** button restores `soundEnabled=true`, `musicEnabled=true`, `volume=0.5` and shows a snackbar confirmation.
- Gradient: teal → green.

#### `categories_screen.dart`

- Displays a **2×3 grid** of category cards using a `LayoutBuilder` to calculate card sizes that fill the screen without scrolling.
- Each card tap:
  1. Plays click sound.
  2. Shuffles the category's questions.
  3. Takes the first 5 shuffled questions.
  4. Navigates to `/quiz` passing `{category: Category, questions: List<Question>}` as route arguments.
- Gradient: orange → yellow.

#### `quiz_screen.dart`

This is the core gameplay screen. Detailed breakdown:

**State variables:**
- `_category` — the `Category` passed via route arguments.
- `_questions` — the 5 selected `Question` objects.
- `_currentIndex` — which question is active (0–4).
- `_score` — number of correct answers so far.
- `_selected` / `_selectedAnswer` — prevents double-tapping and tracks which option was chosen.
- `_showResult` — triggers colour feedback on all 4 buttons.
- `_confettiController` — fires confetti on correct answer.

**Answer flow:**
1. User taps an option → `_selectAnswer(answer)` is called.
2. `_selected` is set to `true` (blocks further taps), `_showResult` to `true`.
3. If correct: `_score++`, plays correct sound, fires confetti.
4. If wrong: plays wrong sound.
5. After **2000 ms** `_nextQuestion()` is called automatically.
6. If more questions remain: resets state, increments `_currentIndex`.
7. If all 5 questions done: navigates to `/results` with `{score, total, category name}`.

**Layout** uses `LayoutBuilder` to make the UI adaptive:
- Image area height = 25% of available screen height.
- Button height clamped between 50–70 dp.
- Answer buttons displayed in a **2×2 `GridView`** with `childAspectRatio: 2.5`.

**Colour logic for buttons:**
- Default: one of 4 vivid colours (red, green, purple, yellow) per position.
- After answer: correct option turns green (✓ icon), wrong selected option turns red (✗ icon).

**Confetti:** positioned at `Alignment.topCenter` using `ConfettiWidget` with explosive blast.

#### `results_screen.dart`

- Reads `score`, `total`, `category` from route arguments.
- Three chained animations (all driven by one 1500 ms `AnimationController`):
  - 0–50%: emoji circle scales in with `elasticOut`.
  - 30–70%: score panel fades in.
  - 50–100%: star row scales/fades in.
- **Star rating:** `(percentage * 3).round()` gives 0, 1, 2, or 3 filled stars.
- **Message & emoji** based on score percentage:

| Score % | Message | Emoji |
|---|---|---|
| 100% | Perfect! 🏆 | 🏆 |
| ≥ 80% | Amazing! ⭐ | 🌟 |
| ≥ 60% | Great Job! 👍 | 😊 |
| ≥ 40% | Good Try! 💪 | 🙂 |
| < 40% | Keep Practicing! 📚 | 💪 |

- **Gradient colour** of the background also changes with score (green = high, purple = mid, red/yellow = low).
- Three navigation buttons: **Play Again** (pop back to quiz), **Choose Category** (pop twice), **Home** (pop three times).

---

### Widgets

#### `widgets/answer_button.dart`

A reusable animated multiple-choice button (currently defined but the quiz screen uses its own inline implementation for the grid). Key properties:

- `isSelected`, `isCorrect`, `showResult` — control the colour state.
- Press animation: scales down to 0.95 on `onTapDown`, bounces back to 1.1 on release via `elasticOut`.
- Colour logic identical to the quiz screen (green for correct, red for wrong-selected).
- Shows ✓ or ✗ icon when `showResult` is true.

#### `widgets/category_card.dart`

- Accepts `name`, `icon`, `onTap`, and `color`.
- Press animation: scales down to 0.95 using a 150 ms controller.
- Gradient background from `color` to `color.withOpacity(0.7)`.
- Plays `AudioService().playClickSound()` on tap.

#### `widgets/quiz_image.dart`

- Accepts `imagePath` (filename without extension) and `category` (folder name).
- Constructs path: `assets/images/<category>/<imagePath>.png`.
- Entry animation: scales from 0.5→1.0 with `elasticOut` + rotates from -0.1→0.0.
- **Fallback placeholder**: if the image file is missing, shows the category icon and image name text on a colour-tinted background.
- Category colours and icons are mapped per category name (fruits=orange/apple, animals=brown/pets, etc.).

---

### Services

#### `services/audio_service.dart`

A **singleton** audio manager (`factory` constructor returns the same `_instance`).

**Two `AudioPlayer` instances:**
- `_musicPlayer` — for the looping background track.
- `_soundPlayer` — for one-shot effect sounds.

**Persistence:** On `init()`, reads `sound_enabled`, `music_enabled`, and `volume` from `SharedPreferences`. All setting changes are written back immediately.

**Public methods:**

| Method | Description |
|---|---|
| `init()` | Loads prefs, creates players, sets volume. Called once in `main()`. |
| `playBackgroundMusic()` | Sets loop mode and plays `audio/background_music.mp3`. Gracefully silent if file missing. |
| `stopBackgroundMusic()` | Stops the music player. |
| `pauseBackgroundMusic()` | Pauses without resetting position. |
| `resumeBackgroundMusic()` | Resumes from paused position. |
| `playCorrectSound()` | Plays `audio/correct.mp3`. |
| `playWrongSound()` | Plays `audio/wrong.mp3`. |
| `playClickSound()` | Plays `audio/click.mp3`. |
| `playCelebrationSound()` | Plays `audio/celebration.mp3`. |
| `setSoundEnabled(bool)` | Toggles sound effects, persists to prefs. |
| `setMusicEnabled(bool)` | Toggles music, stops/starts as needed, persists. |
| `setVolume(double)` | Sets volume on both players (0.0–1.0), persists. |
| `resetSettings()` | Resets all to defaults (sound=true, music=true, volume=0.5). |
| `dispose()` | Disposes both players and resets state. |

All audio failures are caught silently — the app continues working even if audio files are absent.

---

### Data

#### `data/quiz_data.dart`

A top-level `List<Category> categories` with all 60 questions hard-coded. Each question has exactly 4 options and the correct answer always appears among them.

---

## 📚 Quiz Categories & Questions

| Category | Icon | Questions (imageName → correct answer) |
|---|---|---|
| Fruits | 🍎 | apple, banana, orange, grape, mango, strawberry, watermelon, pineapple, cherry, lemon |
| Vegetables | 🥕 | carrot, tomato, broccoli, corn, potato, onion, cucumber, pepper→Bell Pepper, lettuce, eggplant |
| Vehicles | 🚗 | car, bus, bicycle, airplane, train, boat, helicopter, truck, motorcycle, ship |
| Animals | 🦁 | lion, dog, cat, elephant, monkey, rabbit, bird, fish, horse, cow |
| Colors | 🎨 | red, blue, yellow, green, purple, orange_color→Orange, pink, brown, black, white |
| Shapes | ⭐ | circle, square, triangle, star, heart, rectangle, diamond, hexagon, pentagon, oval |

> **Note on the Colors category:** the image for Orange is named `orange_color.png` (not `orange.png`) to avoid a name clash with the Fruits category.

---

## 🖼️ Assets Guide

### Images

Place PNG images in the correct subfolder under `assets/images/`. Recommended size: **512×512 px**.

The image filename must exactly match the `imageName` field in `quiz_data.dart` (lowercase, no spaces, `.png` extension).

**Example — Fruits:**
```
assets/images/fruits/apple.png
assets/images/fruits/banana.png
assets/images/fruits/orange.png
assets/images/fruits/grape.png
assets/images/fruits/mango.png
assets/images/fruits/strawberry.png
assets/images/fruits/watermelon.png
assets/images/fruits/pineapple.png
assets/images/fruits/cherry.png
assets/images/fruits/lemon.png
```

If an image is missing, `quiz_image.dart` automatically shows a coloured placeholder with the category icon and the image name as text — the app will not crash.

### Audio

Place MP3 files in `assets/audio/`. All audio is optional — missing files are caught silently.

| Filename | When played |
|---|---|
| `background_music.mp3` | Loops from Home screen onwards |
| `correct.mp3` | Every correct answer tap |
| `wrong.mp3` | Every wrong answer tap |
| `click.mp3` | Every button tap across the app |
| `celebration.mp3` | Results screen on entry |

---

## 📦 Dependencies

Listed in `pubspec.yaml`:

| Package | Version | Purpose |
|---|---|---|
| `audioplayers` | ^5.2.1 | Cross-platform audio playback (music + SFX) |
| `shared_preferences` | ^2.2.2 | Persist audio settings across app restarts |
| `flutter_animate` | ^4.3.0 | Additional animation helpers |
| `confetti` | ^0.7.0 | Confetti particle burst on correct answers |

---

## 🔗 Clone the Repository

```bash
# Clone via HTTPS
git clone https://github.com/SlingggShottt/kids_quiz_game.git

# Or via SSH
git clone https://github.com/SlingggShottt/kids_quiz_game.git

# Navigate into the project folder
cd kids_quiz_game
```

---

## ⚙️ Installation & Setup

### Prerequisites

Make sure you have the following installed:

1. **Flutter SDK** (3.0.0 or higher)
   - Download from: https://docs.flutter.dev/get-started/install
   - Verify installation: `flutter --version`

2. **Dart SDK** — bundled with Flutter, no separate install needed.

3. **Android Studio** (for Android/emulator) or **Xcode** (for iOS — macOS only)

4. **VS Code** (recommended) with the Flutter and Dart extensions installed.

5. Run the Flutter doctor to confirm your environment is ready:
   ```bash
   flutter doctor
   ```
   Fix any issues flagged before proceeding.

### Install Dependencies

```bash
cd kids_quiz_game
flutter pub get
```

This downloads all packages listed in `pubspec.yaml` into the `.dart_tool/` cache.

### Add Your Assets

1. Create the image folders if they don't already exist:
   ```bash
   mkdir -p assets/images/fruits assets/images/vegetables assets/images/vehicles
   mkdir -p assets/images/animals assets/images/colors assets/images/shapes
   mkdir -p assets/audio
   ```

2. Drop your PNG images and MP3 audio files into the correct folders as described in the [Assets Guide](#-assets-guide).

3. Confirm the asset declarations in `pubspec.yaml` exist:
   ```yaml
   flutter:
     assets:
       - assets/images/fruits/
       - assets/images/vegetables/
       - assets/images/vehicles/
       - assets/images/animals/
       - assets/images/colors/
       - assets/images/shapes/
       - assets/audio/
   ```

---

## 📱 Running on Different Devices

### Check Connected Devices

```bash
flutter devices
```

This lists all connected physical devices and running emulators/simulators.

---

### ▶️ Run on Android Emulator

1. Open Android Studio → **Device Manager** → Start an AVD (e.g. Pixel 6, API 33).
2. Once the emulator is running:
   ```bash
   flutter run
   ```
   Flutter auto-detects the running emulator.

To target a specific device if multiple are connected:
```bash
flutter run -d emulator-5554
```

---

### ▶️ Run on a Physical Android Device

1. On your Android phone go to **Settings → About Phone** → tap **Build Number** 7 times to enable Developer Options.
2. Go to **Settings → Developer Options** → enable **USB Debugging**.
3. Connect your phone via USB. Accept the "Allow USB Debugging" prompt on the phone.
4. Verify it appears:
   ```bash
   flutter devices
   ```
5. Run the app:
   ```bash
   flutter run
   ```

---

### ▶️ Run on iOS Simulator (macOS only)

1. Open Xcode → **Xcode menu → Open Developer Tool → Simulator**.
2. Choose a device (e.g. iPhone 15).
3. Run:
   ```bash
   flutter run
   ```

---

### ▶️ Run on a Physical iPhone (macOS only)

1. Connect your iPhone via USB.
2. Open `ios/Runner.xcworkspace` in Xcode.
3. Set your Apple developer account under **Signing & Capabilities**.
4. Select your device in the Xcode device picker.
5. Run from terminal:
   ```bash
   flutter run
   ```

---

### ▶️ Run on Web (Chrome)

```bash
flutter run -d chrome
```

> Note: Audio behaviour may differ in browsers due to autoplay policies. The app handles this gracefully by catching audio errors silently.

---

## 🏗️ Building a Release APK

A release APK is a standalone installable file for Android that does not require a development machine or USB connection to use.

### Step 1 — Create a Keystore (first time only)

A keystore is a file that digitally signs your APK. You only need to create it once.

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

You will be prompted to enter a password and some identity information. Remember your password — you'll need it every time you build.

### Step 2 — Configure Signing in the Project

Create the file `android/key.properties`:

```properties
storePassword=<your-keystore-password>
keyPassword=<your-key-password>
keyAlias=upload
storeFile=<absolute-path-to>/upload-keystore.jks
```

> **Important:** Add `android/key.properties` to your `.gitignore` — never commit this file to version control.

Edit `android/app/build.gradle` to reference the keystore. Find the `android { ... }` block and add:

```groovy
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### Step 3 — Build the APK

**Fat APK** (works on all Android architectures, larger file size):
```bash
flutter build apk --release
```

**Split APKs per ABI** (smaller files, one per CPU architecture):
```bash
flutter build apk --release --split-per-abi
```

The output APK(s) will be located at:
```
build/app/outputs/flutter-apk/app-release.apk
# or for split:
build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk
build/app/outputs/flutter-apk/app-x86_64-release.apk
```

> For most modern Android phones (2017 onwards), use `app-arm64-v8a-release.apk`.

### Build Without Keystore (Debug-Signed, for personal use only)

If you just want to share the APK quickly for personal testing and don't need a proper keystore:

```bash
flutter build apk --debug
```

Output: `build/app/outputs/flutter-apk/app-debug.apk`

---

## 📲 Installing & Running the APK on a Phone

### Method 1 — Via USB (ADB)

With the phone connected and USB Debugging enabled:

```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

The app will appear in the phone's app drawer immediately.

To replace an existing installation:
```bash
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

### Method 2 — Transfer the File Manually

1. Copy `app-release.apk` to your phone via:
   - **USB file transfer** (drag and drop in Windows Explorer / Finder)
   - **Google Drive / WhatsApp / Telegram** — share the file to yourself
   - **Email attachment**

2. On your Android phone, open the APK file using the **Files** app (or any file manager).

3. If prompted with _"Install from unknown sources"_:
   - Go to **Settings → Apps → Special App Access → Install Unknown Apps**
   - Find your file manager or browser and toggle **Allow from this source**.

4. Tap **Install** and wait for it to complete.

5. The app will appear in your launcher. Tap **Kids Quiz Game** to start playing.

### Uninstalling

To remove the app via ADB:
```bash
adb uninstall com.example.kids_quiz_game
```

Or simply uninstall it like any other app from your phone's Settings → Apps.

---

## 🎨 Customisation Guide

### Add a New Category

1. Add a new `Category` entry in `lib/data/quiz_data.dart`:
   ```dart
   Category(
     name: 'Numbers',
     icon: '🔢',
     questions: [
       Question(
         imageName: 'one',
         correctAnswer: 'One',
         options: ['One', 'Two', 'Three', 'Four'],
       ),
       // Add at least 5 questions (10 recommended)
     ],
   ),
   ```

2. Create the asset folder and add images:
   ```
   assets/images/numbers/one.png
   assets/images/numbers/two.png
   ...
   ```

3. Declare it in `pubspec.yaml`:
   ```yaml
   - assets/images/numbers/
   ```

4. Update `categories_screen.dart` to add a new row for the 7th card (the screen currently shows exactly 6 in a 2×3 grid).

### Change Colour Themes

Each screen has its own gradient defined at the top of its `build()` method:

| Screen | Current Colours |
|---|---|
| Splash | `0xFFFF6B6B` → `0xFFFFE66D` (red/yellow) |
| Home | `0xFF667EEA` → `0xFF764BA2` (purple) |
| Settings | `0xFF11998E` → `0xFF38EF7D` (teal/green) |
| Categories | `0xFFFF6B6B` → `0xFFFFE66D` (red/yellow) |
| Quiz | `0xFF4FACFE` → `0xFF00F2FE` (blue) |
| Results | Dynamic (green/purple/red based on score) |

### Change the Number of Questions Per Session

In `categories_screen.dart`, change the `.take(5)` call:
```dart
final selectedQuestions = shuffledQuestions.take(10).toList(); // 10 questions
```

### Change the Auto-Advance Delay

In `quiz_screen.dart`, find the delay after an answer is selected:
```dart
Future.delayed(const Duration(milliseconds: 2000), () {
```
Change `2000` to any value in milliseconds (e.g. `3000` for 3 seconds).

---

## 📄 License

This project is open source and free to use, modify, and distribute for educational and personal purposes. Just give credits to our github profiles.

---

