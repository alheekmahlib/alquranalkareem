<div dir="ltr">

<p align="center">
  <img src="https://raw.githubusercontent.com/alheekmahlib/data/refs/heads/main/apps_photos/quran_app/quran_logo.png" width="90" alt="Al-Quran Al-Kareem logo"/>
</p>

<h1 align="center">القرآن الكريم — مكتبة الحكمة</h1>
<h3 align="center">Al-Quran Al-Kareem — Al-Heekmah Library</h3>

<p align="center">
  <img src="https://raw.githubusercontent.com/alheekmahlib/data/refs/heads/main/apps_photos/quran_app/play%20store/Feature%20graphic.png" width="100%" alt="Al-Quran Al-Kareem feature graphic"/>
</p>

<p align="center">
  <a href="https://github.com/alheekmahlib/alquranalkareem/releases">
    <img src="https://img.shields.io/github/v/release/alheekmahlib/alquranalkareem?style=for-the-badge&color=2EA44F&label=Release" alt="Latest release"/>
  </a>
  <a href="https://github.com/alheekmahlib/alquranalkareem/actions/workflows/release.yml">
    <img src="https://img.shields.io/github/actions/workflow/status/alheekmahlib/alquranalkareem/release.yml?style=for-the-badge&label=CI&logo=github" alt="CI status"/>
  </a>
  <a href="https://github.com/alheekmahlib/alquranalkareem/stargazers">
    <img src="https://img.shields.io/github/stars/alheekmahlib/alquranalkareem?style=for-the-badge&color=dfb317&label=Stars" alt="GitHub stars"/>
  </a>
  <a href="https://github.com/alheekmahlib/alquranalkareem/network/members">
    <img src="https://img.shields.io/github/forks/alheekmahlib/alquranalkareem?style=for-the-badge&color=8B5CF6&label=Forks" alt="GitHub forks"/>
  </a>
  <a href="https://github.com/alheekmahlib/alquranalkareem/issues">
    <img src="https://img.shields.io/github/issues/alheekmahlib/alquranalkareem?style=for-the-badge&color=E34F26&label=Issues" alt="GitHub issues"/>
  </a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-Stable-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-%E2%89%A5%203.12-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart SDK"/>
  <img src="https://img.shields.io/badge/Version-5.5.0-46A758?style=for-the-badge" alt="App version"/>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20macOS%20%7C%20Windows%20%7C%20Linux%20%7C%20Web-3DDC84?style=for-the-badge" alt="Platforms"/>
  <img src="https://img.shields.io/badge/Languages-10-8B5CF6?style=for-the-badge" alt="Supported languages"/>
</p>

## 📲 Download

<p align="center">
  <a href="https://apps.apple.com/us/app/القرآن-الكريم-مكتبة-الحكمة/id1500153222">
    <img src="https://img.shields.io/badge/App_Store-Download-000000?style=for-the-badge&logo=apple&logoColor=white" alt="Download on the App Store"/>
  </a>
  <a href="https://play.google.com/store/apps/details?id=com.alheekmah.alquranalkareem.alquranalkareem">
    <img src="https://img.shields.io/badge/Google_Play-Get_it_on-414141?style=for-the-badge&logo=googleplay&logoColor=white" alt="Get it on Google Play"/>
  </a>
  <a href="https://appgallery.cloud.huawei.com/marketshare/app/C102051725?locale=en_US&source=appshare&subsource=C102051725">
    <img src="https://img.shields.io/badge/Huawei_AppGallery-Explore-red?style=for-the-badge&logo=huawei&logoColor=white" alt="Explore it on AppGallery"/>
  </a>
  <a href="https://apps.apple.com/app/%D8%A7%D9%84%D9%82%D8%B1%D8%A2%D9%86-%D8%A7%D9%84%D9%83%D8%B1%D9%8A%D9%85-%D9%85%D9%83%D8%AA%D8%A8%D8%A9-%D8%A7%D9%84%D8%AD%D9%83%D9%85%D8%A9/id1660688066">
    <img src="https://img.shields.io/badge/Mac_App_Store-Download-999999?style=for-the-badge&logo=macos&logoColor=white" alt="Download on the Mac App Store"/>
  </a>
</p>

---

## 🕌 About The App

**Al-Quran Al-Kareem (القرآن الكريم — مكتبة الحكمة)** is a free, open-source Quran application built with Flutter for Android, iOS, and macOS (with community builds for desktop and web). It is based on the **King Fahd Complex edition** of the Mushaf and combines a beautiful reading experience with advanced memorization tools, on-device AI recitation verification, a smart AI assistant, and a rich Islamic knowledge library.

The app is under active development — new features are shipped regularly, and contributions from the community are welcome.

---

## ✨ Features

### 📖 Quran Reading

- **King Fahd Complex Mushaf** — the exact print of the Madinah Mushaf, page by page.
- **Two reading modes** — classic page (Mushaf) mode or verse-by-verse mode.
- **Word-by-word interaction** — tap any word to listen to it, or open its analysis.
- **Waqf (stop) signs** — clearly marked pause indicators for correct recitation.
- **Smooth navigation** — jump directly to any surah, page, or juz; instant full-text search across all ayat.

### 🎙️ Tasmee — Recitation Testing & Memorization

The flagship section. Open the Quran page, tap the mic, and recite — the app verifies your recitation word by word, fully **on-device** using an ONNX speech model:

| Mode | How it works |
| --- | --- |
| **Tasmee** | The ayat are hidden; words appear as you recite them correctly. Ideal for testing memorization. |
| **Recitation Corrector** | Ayat stay visible. On a mispronounced word, a sheet opens showing the mistake, plays the correct pronunciation, and repeats until you say it right. |
| **Quran Teacher** | The selected qari recites the ayah first, then you repeat after him — looping until the whole ayah is correct. |

- Switch modes from the mode-selector sheet on the Tasmee bar.
- Every completed page is saved with its results — revisit your history any time from the pages list.
- The recognition model is downloaded once from Tasmee settings (manageable / deletable anytime).

### 🎧 Audio & Recitation

- **Dozens of reciters** for both full-surah and ayah-by-ayah playback.
- **Live ayah highlighting** while listening.
- **Word audio** — listen to any single word to perfect your pronunciation.
- **Playlists** — queue ayat and surahs for continuous listening.
- **Offline mode** — download surahs and listen later without a connection.

### 🤖 AI Assistant & Smart Search

- **Natural-language Quran search** — ask questions and get answers grounded in the Quran, powered by a unified LLM layer (OpenRouter / Zai / Mistral — configurable).
- **Hybrid retrieval** — combines classic keyword search (BM25), vector embeddings, and MCP knowledge services (tafsir & seerah) for accurate, referenced results.
- **Chat history** — your conversations are saved locally for later reference.
- Requires API keys in `assets/.env` (see [Environment Configuration](#-environment-configuration)); the rest of the app works without them.

### 📚 Knowledge Library

- **Multiple tafsir & translations** displayed beside the ayat.
- **Islamic books library** — hadith and tafsir books with chapters, bookmarks, and a comfortable reading view.

### 🕌 Azkar — Hisn al-Muslim

- Complete remembrance collection organized by sections.
- Favorites, fast navigation between categories, and a daily dhikr on the home screen.

### 🔎 Study Tools

- **Similar ayat (Mutashabihat)** — a dedicated section that groups look-alike verses to ease memorization and review.
- **Word morphology & syntax (التصريف والإعراب)** — breakdown of every word.
- **Tajweed rules** — color-coded tajweed, plus the Ten Qira'at where available.

### 📌 Bookmarks, Khatmah & Reading Stats

- Bookmark ayat and pages; resume exactly where you stopped.
- **Khatmah mode** — track your progress completing the Mushaf, with reading-hours statistics.
- Share ayat as beautifully formatted images or text.

### 📅 Calendar & Daily Content

- **Hijri calendar** with a full-year view.
- **Daily ayah** notifications and a home-screen widget.

### 🔄 QR Device Sync

- Sync your bookmarks, khatmah progress, and reading data across your devices **without an account** — pair devices by scanning a QR code (a secret 128-bit room id, relayed through a self-hosted Cloudflare Worker + D1 backend; see [Sync Backend](#-sync-backend)).

### 🎨 Personalization

- Light / dark themes and multiple color schemes.
- Fully offline-capable reading; surah audio can be downloaded for offline use.
- **10 languages**: Arabic, English, Spanish, Indonesian, Kurdish, Filipino, Russian, Somali, Turkish, Bengali.
- Beautiful Uthmani and Naskh fonts, including Urdu (Nastaliq) and Bengali scripts.

---

## 📸 Screenshots

<p align="center">
  <img src="https://raw.githubusercontent.com/alheekmahlib/data/refs/heads/main/apps_photos/quran_app/app%20gellary/p1.png" width="30%" alt="Screenshot 1"/>
  <img src="https://raw.githubusercontent.com/alheekmahlib/data/refs/heads/main/apps_photos/quran_app/app%20gellary/p2.png" width="30%" alt="Screenshot 2"/>
  <img src="https://raw.githubusercontent.com/alheekmahlib/data/refs/heads/main/apps_photos/quran_app/app%20gellary/p3.png" width="30%" alt="Screenshot 3"/>
</p>
<p align="center">
  <img src="https://raw.githubusercontent.com/alheekmahlib/data/refs/heads/main/apps_photos/quran_app/app%20gellary/p4.png" width="30%" alt="Screenshot 4"/>
  <img src="https://raw.githubusercontent.com/alheekmahlib/data/refs/heads/main/apps_photos/quran_app/app%20gellary/p5.png" width="30%" alt="Screenshot 5"/>
</p>

---

## 🛠️ Tech Stack

| Concern | Technology |
| --- | --- |
| Framework | Flutter (Dart SDK ≥ 3.12) |
| State management | GetX (`get`) + `get_it` service locator |
| Local database | Drift (SQLite) + GetStorage |
| Quran engine | [`quran_library`](https://pub.dev/packages/quran_library) |
| Networking | Dio |
| Audio | just_audio via quran_library / audio services |
| On-device AI | `flutter_onnxruntime` (Tasmee speech model), embeddings + BM25 hybrid search |
| Notifications | awesome_notifications, background_fetch |
| Env config | flutter_dotenv |
| Code generation | build_runner (Drift), flutter_gen |

---

## 📂 Project Structure

```
lib/
├── core/                    # App-wide services and utilities
│   ├── services/            # API client, notifications, sync, home widget…
│   ├── utils/               # Constants, extensions, styles
│   └── widgets/             # Shared widgets
├── database/                # Drift databases (bookmarks, …)
├── presentation/
│   ├── controllers/         # Global controllers (settings, theme, …)
│   └── screens/
│       ├── quran_page/      # Mushaf, reading, audio, tasmee, bookmarks, search
│       ├── ai_search/       # AI assistant & hybrid search
│       ├── books/           # Islamic books library
│       ├── adhkar/          # Hisn al-Muslim azkar
│       ├── calendar/        # Hijri calendar
│       ├── sync/            # QR device-sync UI
│       └── …                # home, surah_audio, feedback, whats_new, …
└── main.dart                # Bootstrap (env, DI, storage, notifications)

sync_service/                # Cloudflare Worker + D1 (TypeScript) — QR sync backend
test/                        # Unit & widget tests
```

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK** (stable channel) with **Dart ≥ 3.12** — install via [flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install).
- **Android**: Android Studio with platform tools; `minSdk 24`, `compileSdk 37`.
- **iOS / macOS**: Xcode with an available iOS/macOS simulator or a connected device, plus CocoaPods.
- Verify your setup:

```bash
flutter doctor
```

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/alheekmahlib/alquranalkareem.git
cd alquranalkareem

# 2. Install dependencies
flutter pub get

# 3. (Optional) Configure API keys — see section below
cp assets/.env.example assets/.env   # or create assets/.env manually

# 4. Run the app
flutter run
```

### 🔐 Environment Configuration

The app runs **without any keys** — only the AI Assistant needs them. `assets/.env` is git-ignored; start from the provided template (all listed providers have free tiers):

```bash
cp assets/.env.example assets/.env
# then edit assets/.env and fill in the keys you want
```

| Variable | Provider | Purpose |
| --- | --- | --- |
| `ZAI_API_KEY` | [z.ai](https://z.ai/) | GLM Flash — free & unlimited |
| `MISTRAL_API_KEY` | [Mistral AI](https://console.mistral.ai/) | Mistral Small/Medium — permanent free tier |
| `OPENROUTER_API_KEY` | [OpenRouter](https://openrouter.ai/) | Free models (Nemotron, etc.) |
| `HEEKMAH_MCP_ENDPOINT` | Self-hosted MCP | Islamic sections search (Hadith, Fiqh, Aqeedah) |
| `SEERAH_MCP_ENDPOINT` | Self-hosted MCP | Seerah & history search |

Models whose keys are empty are hidden from the in-app model selector automatically. If the file is missing, the app still starts normally and the AI Assistant shows a friendly configuration error when opened.

### Build & Code Generation

Drift database code is generated — regenerate after changing table definitions:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Release builds:

```bash
# Android APK / App Bundle
flutter build apk --release
flutter build appbundle --release

# iOS / macOS
flutter build ios --release
flutter build macos --release
```

CI (`.github/workflows/`) builds and publishes releases automatically on push to `main`; `release.yml` produces the Android APK and `release-all.yml` builds all platforms.

---

## 🧪 Testing

```bash
flutter test
```

The suite covers the Tasmee modes and word-retry verdicts, results storage, sync logic, playlist storage, the notification engine, azkar data integrity, and more (`test/`).

---

## ☁️ Sync Backend

`sync_service/` is a small **Cloudflare Worker + D1** relay (TypeScript) used by the QR device-sync feature. It is optional for local app development — the app gracefully handles an unreachable sync endpoint.

```bash
cd sync_service
npm install
npm test          # vitest on miniflare
npm run typecheck
```

Deployment instructions (D1 creation, migrations, `wrangler deploy`) are in [`sync_service/README.md`](sync_service/README.md).

---

## 🧰 Troubleshooting

| Problem | Likely cause | Solution |
| --- | --- | --- |
| `flutter pub get` fails on `connectivity_kit` / `multi_store_review` | Git dependencies pulled from GitHub | Ensure you have network access to GitHub and a valid Git setup (`git --version`). Then retry `flutter pub get`. |
| App runs but AI Assistant shows a configuration error | `assets/.env` missing or keys invalid | Create `assets/.env` with at least one provider key (see [Environment Configuration](#-environment-configuration)) and fully restart the app. |
| Tasmee mic button does nothing / model missing | The ONNX speech model isn't downloaded yet | Open **Tasmee settings** on the Quran page and download the model (one-time, requires internet). |
| Tasmee recognition is poor | Mic permission or noisy environment | Grant microphone permission in system settings; recite closer to the mic in a quiet place. You can also delete & re-download the model from Tasmee settings. |
| Audio not playing / downloading | No internet or storage pressure | Check connectivity, free storage; downloaded surahs work offline — re-download if a file was corrupted. |
| `Build failed ... dart compile` errors after editing Drift tables | Generated code out of date | Run `dart run build_runner build --delete-conflicting-outputs` and rebuild. |
| Android build fails with SDK errors | Wrong platform tools | Open Android Studio → SDK Manager, install SDK 37 / matching build tools, then `flutter clean && flutter pub get`. |
| iOS build fails at pod install | Outdated CocoaPods repos | `cd ios && pod install --repo-update` (repeat in `macos/` for macOS). |
| Run fails: device not detected | Platform tooling issues | Run `flutter doctor -v`, start an emulator or connect a device, confirm with `flutter devices`. |
| Stale build / weird UI glitches after pulling changes | Cached artifacts | `flutter clean && flutter pub get` then rerun. |
| QR sync pairing fails | Sync worker unreachable or room expired | Both devices need internet; create a new room (new QR) and scan again. |
| Gradle `minSdk 24` error on old device | Device Android version < 7.0 | Use a device with Android 7.0 (API 24) or newer. |

---

## 🤝 Contributing

Contributions are most welcome! The app is under active development and there is a roadmap of upcoming features.

1. Fork the repository and create a feature branch (`git checkout -b feature/my-feature`).
2. Follow the existing code style — run `dart format` and make sure `flutter analyze` and `flutter test` pass.
3. Add or update tests for the behavior you change.
4. Open a Pull Request with a clear description of what changed and why.

Found a bug or have an idea? Please [open an issue](https://github.com/alheekmahlib/alquranalkareem/issues).

---

## ⭐ Show Your Support

If you like the app, please ⭐ star the repository and consider [rating it on the stores](#-download) — it helps others discover it, jazaakum Allahu khairan.

---

## 🔗 More From Al-Heekmah Library

Explore the rest of the family of apps on GitHub: [@alheekmahlib](https://github.com/alheekmahlib)

</div>
