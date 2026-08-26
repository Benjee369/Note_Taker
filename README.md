# <div align="center">📝 NOTE TAKER 📝</div>

<div align="center">


![](https://img.shields.io/badge/Platform-Everything-blueviolet?style=for-the-badge)
![](https://img.shields.io/badge/Price-$0-success?style=for-the-badge)
![](https://img.shields.io/badge/Subscriptions-NO-red?style=for-the-badge)

</div>

---

I have often never been able to find a simple note taking app that will sync my notes from my **PC (Windows)** and my **phone (iOS)**.
I understand theres options like **Obsidian**, but such solutions are either not straight forward on how one can setup syncing, or one has to pay.

# **I HATE THAT.**
> *[options like google docs exist but meh, too bland]*

---

A note taker app that **'will'** work across all platforms, all devices.
Trying to be device inclusive in this ho.

---

And ofcourse this is also meant to be a way to truly understand Flutter capabilities.
I have often viewed it as a framework for building mobile applications...
but theres more to that.
### It is capable of so much more.

*"One codebase to rule them all."*

</div>

---

# How it works

## What this app is

A cross-platform note taker built with Flutter. The same codebase runs on **desktop** (Windows, macOS, Linux) and **mobile** (Android, iOS), plus web. Notes are stored **locally** on-device using **Hive** (a fast key-value store), so there's no account, no subscription, and nothing uploaded to a server. Notes are saved as plain text with a **live markdown preview** on the side.

## Folder layout (feature-first architecture)

The code is organised into three layers. Everything that can be shared is shared; only the parts that genuinely differ per platform live in the platform folders.

```
lib/
├── main.dart                 # Entry point. Wires the setup wizard or the app up
├── app/                      # Bootstrap / wiring
│   ├── app.dart              # Root MaterialApp + light/dark themes
│   ├── provider_layer.dart   # Registers all databases & providers (DI)
│   └── setup_wizard.dart     # First-run flow: pick where to store your notes
├── shared/                   # Code reused everywhere
│   ├── constants/            # app_colors, app_images, app_sizes, strings
│   ├── database/             # Hive boxes (notes, previews, folders, settings...)
│   ├── models/               # Data models (notes, folders, settings)
│   ├── navigation/           # Route helpers
│   ├── providers/            # State management (NoteProvider, settings...)
│   └── widgets/              # Reusable UI pieces
├── auth/
│   └── splash_screen.dart    # Loading / entry screen
├── features/                 # Business features
│   ├── notes/
│   │   ├── home_screen.dart  # The coordinator: picks the platform home screen
│   │   ├── note_screen.dart  # The shared note editor (text + markdown)
│   │   └── widgets/
│   └── settings/
│       ├── settings_screen.dart
│       ├── providers/
│       └── widgets/
└── platform/                 # The only platform-specific UI
    ├── desktop/              # Desktop home screen + note drawer
    └── mobile/               # Mobile home screen + drawer
```

## How a note flows through the app

1. **Startup** — `main()` checks `SharedPreferences` for a saved storage location. If there's none yet it shows the **setup wizard** to let you pick one; otherwise it starts Hive and launches `ProviderLayer`.
2. **Wiring** — `ProviderLayer` creates the Hive-backed databases and the state providers, then hands control to `App`, which builds the themed `MaterialApp` and shows the splash screen.
3. **Platform branch** — the splash navigates to the notes `HomeScreen`, which checks `isMobile`/`isDesktop` (via `platform_provider.dart`) and shows either the **mobile** or **desktop** home screen. That single branch is the *only* place the two platform UIs meet.
4. **Reading/writing** — every screen talks to a provider (e.g. `NoteProvider`), which talks to the databases. Changes are written straight to local Hive boxes — no network calls.

## Adding a new platform-specific screen

Add it under `platform/<platform>/`, keep any shared logic/widgets in `shared/` or `features/`, and branch to it from `features/notes/home_screen.dart` (or wherever the relevant coordinator lives). Avoid importing across the two `platform/` folders — that's what keeps the two platforms decoupled.

## Regenerating code

The `*.g.dart` files are generated from the `@JsonSerializable()` models. After changing a model, run:

```
flutter pub run build_runner build --delete-conflicting-outputs
```

