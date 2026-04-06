# 🚀 PalCareer Architecture & Remote Config Refactoring Plan 🚀

> **Note to Next AI Agent:** The user has requested a comprehensive overhaul to make the app dynamically configurable (Texts, Colors, and Career Taxonomies) via JSON/Remote configuration, alongside a deep structural cleanup. Follow this plan strictly.

## 🎯 Primary Objectives
1. **JSON/Remote-Driven Content**: Decouple all static strings, colors, and taxonomies from the Dart source code.
2. **Codebase Cleanup**: Standardize folder structure, fix tech debts, and eliminate unused variables/imports.
3. **Future-Proofing**: Ensure any non-developer can update app content or themes without issuing a new app update.

---

## 🛠️ Phase 1: Dynamic Configuration (Remote JSON / Local JSON)

### 1.1 Configurable App Texts & Localization
*Current State:* The app uses `flutter_localizations` via `.arb` files or hardcoded static texts in some files.
*Action:*
- Implement **`easy_localization`** or build a custom `RemoteConfigProvider` that reads a JSON structure.
- Move **ALL** UI labels, error messages, and dialogue texts into `/assets/i18n/ar.json` and `en.json`.
- Integrate Firebase Remote Config so that `texts.json` can be overwritten remotely.

### 1.2 Configurable Theme & Colors
*Current State:* Colors are hardcoded in `lib/core/theme/app_colors.dart`.
*Action:*
- Convert `AppColors` from `static const` fields to a dynamic `ThemeExtension` or a Riverpod-managed `ThemeConfig` class.
- Create a `theme_config.json` that sets Hex codes for Primary, Secondary, Background, etc.
- Upon app start (`main.dart`), check local storage (Hive) or Firebase Remote Config for `visual_theme` JSON, parse it, and inject it into `MaterialApp.theme`.

### 1.3 Dynamic Career Taxonomy (Sectors & Specializations)
*Current State:* Hardcoded arrays in `lib/shared/models/career_taxonomy.dart`.
*Action:*
- Establish a new Firestore Collection: `app_config` -> Document: `career_taxonomies`.
- **Alternative:** Host a `taxonomy.json` file remotely.
- Create a `TaxonomyRepository` and a `taxonomyProvider` (Riverpod `FutureProvider`) that fetches these categorizations on app launch, and caches them using `Hive`.
- The Onboarding screens and Jobs providers must await this provider instead of importing the static Dart file.

---

## 🧹 Phase 2: Code Restructuring & Cleanup (Clean Architecture)

### 2.1 Directory Structure Standardization
Ensure the project strictly follows Feature-First Clean Architecture:
```text
lib/
 ├── core/              # Global setups (router, constants, remote_config)
 ├── shared/            # Shared models, widgets, utility functions
 ├── features/          # Feature silos
 │    ├── jobs/
 │    │    ├── screens/
 │    │    ├── widgets/
 │    │    ├── providers/
 │    │    ├── repositories/
 │    ├── onboarding/
 │    ├── profile/
 │    ├── notifications/
 └── main.dart          # App initialization & ProviderScope
```
*Action:* Move any misplaced layout, provider, or model into its perspective bounded context.

### 2.2 Refactoring Fat Files
*Action:* Analyze and split large files (e.g., `jobs_feed_screen.dart`, `onboarding_screen.dart`).
- Extract generic widgets (like `PrimaryButton`, `JobCardWidget`) to either `feature/widgets` or `shared/widgets`.
- Ensure Screens only handle declarative UI layout and state watching, pushing all business logic into `StateNotifier` or `Notifier` classes.

### 2.3 Linting & Dead Code Elimination
*Action:* 
- Adjust `analysis_options.yaml` to include strict linting (`flutter_lints` / `lints/recommended.yaml`).
- Run `dart fix --apply` or explicitly resolve all undefined properties, unused imports, empty blocks, and redundant type checks.

---

## 🚦 Execution Workflow (For The Next Agent)

1. **Step 1:** Add JSON dependency (`easy_localization`) and Firebase Remote Config. Setup `assets/` directory.
2. **Step 2:** Refactor `AppColors` and create `AppThemeManager`. Replace static color references across the app.
3. **Step 3:** Migrate `career_taxonomy.dart` to a Firestore fetching logic and inject it via `Provider`.
4. **Step 4:** Execute the heavy code-cleanup. Separate Widgets, clean imports, run full analysis build.
5. **Step 5:** Provide exactly 1 new Walkthrough explaining how the Client/Admin can change colors, texts, and taxonomies without rebuilding the app.

---
**End of Plan.** 
*Client: Please reference this file (`REFACTOR_PLAN.md`) in your new conversation so the new agent can begin executing it immediately.*
