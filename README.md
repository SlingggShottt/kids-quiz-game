# 🎮 Kids Quiz Game — Flutter E-Learning App

A fun, interactive learning app for children aged **3–8 years**, built with Flutter. The app has two modes: a **quiz module** where kids identify images across 6 categories, and a **mini-games module** with 3 interactive games (Spot the Difference, Alphabet, Numbers). All screens fit without scrolling on any device size — phone, tablet, or browser.

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
6. [Mini-Games](#mini-games)
7. [Assets Guide](#assets-guide)
8. [Dependencies](#dependencies)
9. [Clone the Repository](#clone-the-repository)
10. [Installation & Setup](#installation--setup)
11. [Running on Different Devices](#running-on-different-devices)
12. [Building a Release APK](#building-a-release-apk)
13. [Installing & Running the APK on a Phone](#installing--running-the-apk-on-a-phone)
14. [Customisation Guide](#customisation-guide)

---

## ✨ Features

| Feature | Details |
|---|---|
| 🎨 Kid-Friendly UI | Bright gradients, large rounded buttons, emoji icons |
| 📚 6 Quiz Categories | Fruits, Vegetables, Vehicles, Animals, Colors, Shapes |
| ❓ 60 Questions | 10 questions per category, randomly shuffled |
| 🎮 Quiz Gameplay | 4-option multiple choice, 5 questions per session |
| 🔍 Spot the Difference | Tap the odd emoji out in a 4×4 grid — 10 rounds |
| 🔤 Alphabet Game | Match emojis to their starting letter — 10 rounds |
| 🔢 Numbers Game | Count the emojis and pick the right number — 10 rounds |
| 🎵 Sound System | Background music, correct/wrong/click/celebration sounds |
| ⭐ Star Scoring | 0–3 stars based on percentage correct |
| 🎊 Confetti | Confetti burst animation on every correct answer |
| ⚙️ Settings | Toggle sound effects, background music, and master volume |
| 💾 Persistent Settings | Audio preferences saved with SharedPreferences |
| 📱 Cross-Platform | iOS, Android, and Web |
| 📐 No-Scroll Layouts | LayoutBuilder ensures everything fits on screen without scrolling |

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
Categories Screen      ← 4 rows: 3 quiz rows (2 cards each) + 1 mini-games row (3 cards)
    │
    ├──► Quiz Screen        ← 5 random questions from the selected quiz category
    │       │                  Image area + question text + 2×2 answer grid
    │       │                  Correct = green + confetti; Wrong = red highlight
    │       ▼
    │    Results Screen     ← Score display, 0–3 stars, Play Again / Choose Category / Home
    │
    ├──► Spot the Difference ← Tap the one emoji that's different in a 4×4 grid
    │       ▼
    │    Results Screen
    │
    ├──► Alphabet Game      ← See an emoji + word, pick the starting letter
    │       ▼
    │    Results Screen
    │
    └──► Numbers Game       ← Count the emojis, tap the right number
            ▼
         Results Screen
```

---

## 🗂️ Project Structure

```
kids_quiz_game/
├── lib/
│   ├── main.dart                          # App entry point, routes, theme
│   ├── models/
│   │   ├── question.dart                  # Question data model
│   │   └── category.dart                  # Category data model (with gameRoute)
│   ├── screens/
│   │   ├── splash_screen.dart             # Animated intro screen
│   │   ├── home_screen.dart               # Main menu (Play + Settings)
│   │   ├── settings_screen.dart           # Audio settings
│   │   ├── categories_screen.dart         # 9-category picker (quiz + games)
│   │   ├── quiz_screen.dart               # Core quiz gameplay
│   │   ├── results_screen.dart            # Score & stars display
│   │   ├── spot_the_difference_screen.dart # Odd-one-out emoji game
│   │   ├── alphabet_screen.dart           # Letter-recognition game
│   │   └── numbers_screen.dart            # Counting game
│   ├── widgets/
│   │   ├── answer_button.dart             # Animated multiple-choice button
│   │   ├── category_card.dart             # Tappable category card with press animation
│   │   └── quiz_image.dart               # Animated image/placeholder widget
│   ├── services/
│   │   └── audio_service.dart             # Singleton audio manager
│   └── data/
│       └── quiz_data.dart                 # 6 quiz categories + 3 game entries
├── assets/
│   ├── images/
│   │   ├── fruits/                        # apple.png, banana.png, ... (10 images)
│   │   ├── vegetables/                    # carrot.png, tomato.png, ... (10 images)
│   │   ├── vehicles/                      # car.png, bus.png, ... (10 images)
│   │   ├── animals/                       # lion.png, dog.png, ... (10 images)
│   │   ├── colors/                        # red.png, blue.png, ... (10 images)
│   │   └── shapes/                        # circle.png, square.png, ... (10 images)
│   └── audio/
│       ├── background_music.mp3           # Looping background track
│       ├── correct.mp3                    # Played on correct answer
│       ├── wrong.mp3                      # Played on wrong answer
│       ├── click.mp3                      # Played on any button tap
│       └── celebration.mp3               # Played on results screen
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
| `/spot-the-difference` | `SpotTheDifferenceScreen` |
| `/alphabet` | `AlphabetScreen` |
| `/numbers` | `NumbersScreen` |

- Uses Material 3 theming with a blue seed colour.

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
  final List<Question> questions; // Quiz questions (empty for game categories)
  final String? gameRoute;        // Non-null → routes to a game screen instead of quiz
}
```

`gameRoute` is the key addition: when non-null the categories screen navigates to a dedicated game screen instead of the standard quiz flow. Game categories don't need any `questions`.

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

Redesigned to display all **9 categories** on one screen with no scrolling:

- Uses `LayoutBuilder` inside an `Expanded` to compute card heights at runtime:
  `cardH = ((maxHeight - fixedOverhead) / 4).clamp(48, 160)`
- **Two labelled sections:**
  - `📚 Quiz Categories` — 3 rows of 2 cards (the 6 image-quiz categories)
  - `🎮 Mini Games` — 1 row of 3 cards (Spot the Difference, Alphabet, Numbers)
- Game cards show a small **"GAME" badge** (top-right corner) via `Stack + Positioned`.
- **Navigation logic:** if `category.gameRoute != null` → `Navigator.pushNamed(context, category.gameRoute!)`, otherwise shuffle questions and push `/quiz`.

#### `quiz_screen.dart`

The core quiz gameplay screen.

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

#### `results_screen.dart`

- Reads `score`, `total`, `category` from route arguments.
- Three chained animations (all driven by one 1500 ms `AnimationController`):
  - 0–50%: emoji circle scales in with `elasticOut`.
  - 30–70%: score panel fades in.
  - 50–100%: star row scales/fades in.
- **Star rating:** `(percentage * 3).round()` gives 0, 1, 2, or 3 filled stars.
- Three navigation buttons: **Play Again**, **Choose Category**, **Home**.

#### `spot_the_difference_screen.dart`

An "odd one out" game. A **4×4 grid of 16 emoji tiles** is shown — 15 are identical, 1 is different. The child taps the odd tile. 10 rounds per session.

- Emoji pairs are chosen from visually unrelated categories (e.g. 🐶 vs 🍕, ⭐ vs 🍎) so the odd tile is obvious even at small sizes.
- The grid uses `LayoutBuilder` to compute `childAspectRatio = cellWidth / cellHeight` so all 16 tiles always fit the available space on any screen size — phones and wide web browsers included.
- `NeverScrollableScrollPhysics()` keeps the `GridView` bounded inside the `Expanded` area.
- Correct tap → confetti + green highlight. Wrong tap → odd tile revealed green, tapped tile red. Auto-advances after 1.5 s.
- Gradient: pink → purple.

#### `alphabet_screen.dart`

Teaches letter recognition. Shows an emoji + word; child picks which letter the word starts with from 4 large letter buttons. 10 questions from a full A–Z dataset per session.

- Dataset: 26 Dart 3 positional records `(String letter, String emoji, String word)`.
- Layout uses `Expanded(flex: 3)` for the question card and `Expanded(flex: 2)` for the options, preventing overflow on all screen sizes.
- Options are a 2×2 grid built from `Column + Row` (not `GridView`) so it works correctly inside `Expanded` without `shrinkWrap`.
- `FittedBox(fit: BoxFit.scaleDown)` around the emoji prevents overflow on small screens.
- Gradient: green → teal.

#### `numbers_screen.dart`

Teaches counting. Shows N copies of an emoji; child taps the correct count from 4 number buttons. Numbers 1–10 each appear exactly once per session (shuffled).

- Emoji objects displayed via `Wrap(alignment: WrapAlignment.center)` inside an `Expanded` container — flows across multiple lines automatically.
- Answer buttons live in a fixed-height `SizedBox(height: 64)` to prevent overflow regardless of screen size.
- Four vivid button colours (red, green, blue, yellow) with `AnimatedContainer` colour transitions.
- Gradient: blue → pink.

---

### Widgets

#### `widgets/answer_button.dart`

A reusable animated multiple-choice button. Key properties:

- `isSelected`, `isCorrect`, `showResult` — control the colour state.
- Press animation: scales down to 0.95 on `onTapDown`, bounces back to 1.1 on release via `elasticOut`.
- Shows ✓ or ✗ icon when `showResult` is true.

#### `widgets/category_card.dart`

- Accepts `name`, `icon`, `onTap`, and `color`.
- Press animation: scales down to 0.95 using a 150 ms controller.
- Gradient background from `color` to `color.withOpacity(0.7)`.

#### `widgets/quiz_image.dart`

- Constructs path: `assets/images/<category>/<imagePath>.png`.
- Entry animation: scales from 0.5→1.0 with `elasticOut` + rotates from -0.1→0.0.
- **Fallback placeholder**: if the image is missing, shows the category icon and image name on a tinted background — the app will not crash.

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
| `playBackgroundMusic()` | Sets loop mode and plays `audio/background_music.mp3`. |
| `stopBackgroundMusic()` | Stops the music player. |
| `playCorrectSound()` | Plays `audio/correct.mp3`. |
| `playWrongSound()` | Plays `audio/wrong.mp3`. |
| `playClickSound()` | Plays `audio/click.mp3`. |
| `playCelebrationSound()` | Plays `audio/celebration.mp3`. |
| `setSoundEnabled(bool)` | Toggles sound effects, persists to prefs. |
| `setMusicEnabled(bool)` | Toggles music, stops/starts as needed, persists. |
| `setVolume(double)` | Sets volume on both players (0.0–1.0), persists. |
| `resetSettings()` | Resets all to defaults (sound=true, music=true, volume=0.5). |

All audio failures are caught silently — the app continues working even if audio files are absent.

---

### Data

#### `data/quiz_data.dart`

A top-level `List<Category> categories` containing:
- **6 quiz categories** — each with 10 `Question` objects referencing image assets.
- **3 game entries** — `gameRoute` set, no questions needed.

```dart
// Game entries (appended after the 6 quiz categories)
Category(name: 'Spot the Difference', icon: '🔍', gameRoute: '/spot-the-difference'),
Category(name: 'Alphabet',            icon: '🔤', gameRoute: '/alphabet'),
Category(name: 'Numbers',             icon: '🔢', gameRoute: '/numbers'),
```

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

## 🎮 Mini-Games

### 🔍 Spot the Difference
A 4×4 grid of 16 emoji tiles — 15 are identical, 1 is different. Tap the odd one out. 10 rounds per session. Emoji pairs come from completely different visual categories (animal vs food, vehicle vs symbol, etc.) so the odd tile is always obvious.

### 🔤 Alphabet Game
See an emoji and its English name (e.g. 🐘 Elephant). Tap the letter it starts with from 4 options. 10 questions per session, drawn randomly from a full 26-letter A–Z dataset.

### 🔢 Numbers Game
A collection of identical emojis is shown. Count them and tap the correct number from 4 options. Numbers 1–10 each appear exactly once per session, in a shuffled order.

All mini-games:
- Run for 10 rounds
- Track score throughout
- Play audio feedback (correct chime / wrong buzz)
- Fire confetti on correct answers
- Navigate to the shared Results Screen at the end

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
...
```

If an image is missing, `quiz_image.dart` automatically shows a coloured placeholder — the app will not crash.

### Audio

Place MP3 files in `assets/audio/`. All audio is optional — missing files are caught silently.

| Filename | When played |
|---|---|
| `background_music.mp3` | Loops from Home screen onwards |
| `correct.mp3` | Every correct answer (quiz + mini-games) |
| `wrong.mp3` | Every wrong answer (quiz + mini-games) |
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
git clone https://github.com/SlingggShottt/kids_quiz_game.git
cd kids_quiz_game
```

---

## ⚙️ Installation & Setup

### Prerequisites

1. **Flutter SDK** (3.0.0 or higher) — https://docs.flutter.dev/get-started/install
2. **Dart SDK** — bundled with Flutter.
3. **Android Studio** (for Android/emulator) or **Xcode** (for iOS — macOS only)

Verify your environment:
```bash
flutter doctor
```

### Install Dependencies

```bash
flutter pub get
```

### Add Your Assets

```bash
mkdir -p assets/images/fruits assets/images/vegetables assets/images/vehicles
mkdir -p assets/images/animals assets/images/colors assets/images/shapes
mkdir -p assets/audio
```

Drop your PNG images and MP3 files into the correct folders as described in the [Assets Guide](#-assets-guide).

---

## 📱 Running on Different Devices

```bash
flutter devices          # list connected devices
flutter run              # run on the default device
flutter run -d chrome    # run on web
flutter run -d emulator-5554  # target a specific device
```

---

## 🏗️ Building a Release APK

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk

# Smaller split APKs per CPU architecture:
flutter build apk --release --split-per-abi
```

For most modern Android phones (2017 onwards) use `app-arm64-v8a-release.apk`.

---

## 📲 Installing & Running the APK on a Phone

**Via ADB:**
```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

**Manually:** Transfer the APK to your phone via USB / Google Drive / WhatsApp, open it with your file manager, and tap **Install**. You may need to enable *Install from unknown sources* in Settings → Apps → Special App Access.

---

## 🎨 Customisation Guide

### Add a New Quiz Category

1. Add a `Category` entry in `lib/data/quiz_data.dart` with `questions` and no `gameRoute`.
2. Create `assets/images/<category>/` and add 10 PNG images.
3. Declare the folder in `pubspec.yaml`.

### Add a New Mini-Game

1. Create your game screen in `lib/screens/`.
2. Register a named route in `main.dart`.
3. Add a `Category` entry in `quiz_data.dart` with `gameRoute` pointing to that route (no `questions` needed).

The categories screen automatically places it in the **Mini Games** row.

### Change the Number of Questions Per Session

In `categories_screen.dart`, change the `.take(5)` call:
```dart
'questions': shuffled.take(10).toList(), // 10 questions per session
```

### Change Screen Colour Themes

| Screen | Current Colours |
|---|---|
| Splash / Categories | `#FF6B6B` → `#FFE66D` (red/yellow) |
| Home | `#667EEA` → `#764BA2` (purple) |
| Settings | `#11998E` → `#38EF7D` (teal/green) |
| Quiz | `#4FACFE` → `#00F2FE` (blue) |
| Spot the Difference | `#FF9A9E` → `#A18CD1` (pink/purple) |
| Alphabet | `#43E97B` → `#38F9D7` (green/teal) |
| Numbers | `#4FACFE` → `#F09EBB` (blue/pink) |

---

## 📄 License

This project is open source and free to use, modify, and distribute for educational and personal purposes. Credit to the authors' GitHub profiles is appreciated.
