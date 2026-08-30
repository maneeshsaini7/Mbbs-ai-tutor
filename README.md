# MBBS AI Tutor — Phase 1

A free, original MBBS study app (Flutter, Android + iOS) for students preparing for
university exams such as RUHS. This is Phase 1 only: architecture, navigation, and the
Home screen with mock data, as requested. Everything else (auth, AI calls, PDF/RAG,
MCQs, flashcards, PYQs, planner, analytics) is stubbed behind clean interfaces so the UI
already runs, and each later phase plugs a real implementation into the same interface.

---

## 1. Architecture

**Pattern:** Clean Architecture, feature-first, with a thin MVVM-ish presentation layer.

```
Presentation (screens/widgets, per feature)
        │  calls
        ▼
Domain (repository interfaces + models)  — pure Dart, no Flutter/Firebase imports
        │  implemented by
        ▼
Data (repository implementations: mock now, Firebase/Supabase/API later)
```

Rules that make later phases painless:

- **Screens never call Firebase/HTTP directly.** They only call a `Repository` interface
  (e.g. `AiTutorRepository`, `SubjectRepository`). Phase 1 wires each interface to a
  `Mock*Repository`. Later phases swap in a `Firebase*Repository` / `Http*Repository`
  without touching a single screen.
- **State management:** `provider` (simple, small learning curve, well-documented,
  scales fine for this app size). Each feature gets its own `ChangeNotifier` view-model
  that depends on a repository interface, not a concrete implementation.
- **Dependency injection:** a single `AppProviders` widget (see `lib/app/app.dart`)
  constructs concrete repositories once and exposes interfaces down the tree via
  `Provider`/`ChangeNotifierProvider`. Swapping mock → real happens in exactly one file.
- **Navigation:** `go_router` with named routes and a `StatefulShellRoute` for the 5-tab
  bottom navigation, so each tab keeps its own back-stack (industry-standard pattern for
  bottom-nav apps, avoids losing scroll/state when switching tabs).

## 2. Folder structure

```
mbbs_ai_tutor/
├── pubspec.yaml
├── .env.example                 # names of required secrets, no real values
├── README.md
└── lib/
    ├── main.dart                 # entrypoint, loads config, runs App
    ├── app/
    │   ├── app.dart               # MaterialApp.router + DI providers
    │   ├── routes.dart            # go_router config, bottom-nav shell
    │   └── theme/
    │       ├── app_colors.dart
    │       ├── app_typography.dart
    │       └── app_theme.dart     # light + dark ThemeData
    ├── config/
    │   └── env.dart               # reads secrets from --dart-define / .env, never hardcoded
    ├── core/
    │   ├── constants/
    │   │   └── app_spacing.dart
    │   ├── services/
    │   │   └── ai_service.dart    # abstract AiService — the "swap AI provider" seam
    │   └── widgets/
    │       ├── app_bottom_nav.dart
    │       ├── app_card.dart
    │       ├── section_header.dart
    │       ├── stat_pill.dart
    │       └── primary_button.dart
    ├── data/
    │   ├── models/
    │   │   ├── user_profile.dart
    │   │   ├── subject.dart
    │   │   ├── topic.dart
    │   │   └── study_task.dart
    │   ├── repositories/
    │   │   ├── subject_repository.dart      # abstract interface
    │   │   └── study_plan_repository.dart   # abstract interface
    │   └── mock/
    │       ├── mock_subject_repository.dart
    │       ├── mock_study_plan_repository.dart
    │       └── mock_data.dart               # seed data for Phase-2 UI screens
    └── features/
        ├── home/
        │   ├── screens/home_screen.dart
        │   └── widgets/ (greeting_header, streak_card, quick_actions_grid, ...)
        ├── subjects/screens/subjects_screen.dart      # placeholder, Phase 4
        ├── ai_tutor/screens/ai_tutor_screen.dart      # placeholder, Phase 5
        ├── practice/screens/practice_screen.dart      # placeholder, Phase 6/9
        └── profile/screens/profile_screen.dart        # placeholder, Phase 3/11
```

## 3. Database structure (Firebase/Firestore — swappable for Supabase/Postgres)

Document-oriented, keyed for the query patterns the app actually needs (per-user reads,
per-subject reads), not a raw relational dump.

```
users/{uid}
  name, mbbsYear, university, subjects[], darkMode, createdAt

users/{uid}/progress/{subjectId}
  masteryPercent, weakTopics[], strongTopics[], studyStreak, lastStudiedAt

subjects/{subjectId}
  name, order, icon

subjects/{subjectId}/topics/{topicId}
  title, overview, detailedExplanation, importantPoints[], clinicalCorrelation,
  order

subjects/{subjectId}/topics/{topicId}/mcqs/{mcqId}
  question, options[4], correctIndex, explanation, clinicalPearl, difficulty

subjects/{subjectId}/topics/{topicId}/flashcards/{cardId}
  front, back, sourceType ("authored" | "ai_generated" | "from_pdf")

users/{uid}/flashcardProgress/{cardId}
  status ("known" | "review_again"), lastReviewedAt, reviewCount

pyq/{universityId}/{subjectId}/{year}/{questionId}
  type ("long" | "short" | "mcq" | "viva"), text, marks, topicTag,
  -- only ever written from verified/licensed/user-provided sources, never AI-invented

users/{uid}/uploadedDocs/{docId}
  fileName, storagePath, status ("processing" | "ready" | "failed"), createdAt
users/{uid}/uploadedDocs/{docId}/chunks/{chunkId}
  text, embeddingRef, pageNumber        -- chunk metadata; vectors live in a vector store, see §4

users/{uid}/studyPlan/{taskId}
  date, subjectId, topicId, durationMin, done, isRevision

chatSessions/{uid}/{sessionId}/messages/{messageId}
  role ("user" | "ai"), text, createdAt, contextType ("general" | "pdf" | "clinical_case")
```

Security rules (Phase 3): every path under `users/{uid}/...` readable/writable only by
that `uid`; `subjects/`, `pyq/` are read-only for clients and written only by an admin
role; file uploads validated server-side for type/size before a `chunks` doc is created.

## 4. AI architecture

Two concerns kept separate on purpose: **general tutoring** (no document context) and
**RAG over an uploaded PDF** (must ground answers in that PDF).

```
Screen (AiTutorScreen / PdfStudyScreen)
   │
   ▼
AiTutorViewModel (ChangeNotifier)
   │  calls
   ▼
AiService  (abstract interface — lib/core/services/ai_service.dart)
   │  implemented by
   ▼
Backend function (Cloud Function / Supabase Edge Function)
   │  never the client — API key never ships in the app
   ▼
LLM provider (swappable: Anthropic, OpenAI, etc. — provider name lives in one
   backend config value, not scattered through app code)
```

- **`AiService` is the only seam the app code touches.** It exposes methods like
  `explainTopic()`, `generateMcqs()`, `generateFlashcards()`, `askAboutDocument()`,
  `runClinicalCase()`. Phase 1 ships a `MockAiService` so UI work in later phases isn't
  blocked on backend setup.
- **Provider-agnostic:** the client never imports an AI SDK. It calls your own backend
  endpoint; the backend holds the API key (as an environment variable on the server, per
  the "no keys in client" requirement) and can be repointed to a different LLM vendor
  without an app release.
- **RAG for PDFs (Phase 7):** on upload, the backend extracts text, chunks it, embeds
  each chunk, and stores vectors (e.g. a vector column in Postgres/Supabase, or a
  dedicated vector DB). A question against a PDF retrieves only the top-k relevant
  chunks and sends *those* to the LLM — not the whole PDF — keeping cost and latency
  bounded regardless of document length.
- **Clinical Case Simulator** uses the same `AiService`, with a system prompt that keeps
  the model in "examiner/patient" role and requires the UI to always render the
  "educational simulation, not real patient advice" disclaimer already specified.
- **Guardrails baked into every AI prompt template (server-side, not client-side, so
  they can't be bypassed):** MBBS-level language, cite uncertainty rather than invent
  facts, never claim to replace a doctor, and offer simpler/deeper/viva/MCQ variants of
  the same answer on request.

## 5. Required packages (pubspec.yaml)

| Package | Why |
|---|---|
| `provider` | lightweight state management / DI |
| `go_router` | declarative routing + bottom-nav shell with per-tab back-stacks |
| `google_fonts` | typography without bundling font files by hand |
| `flutter_svg` | crisp vector icons/illustrations |
| `cached_network_image` | avoid re-fetching images, graceful loading/error states |
| `shimmer` | loading skeletons for slow networks |
| `intl` | date/number formatting |
| `flutter_dotenv` | local `.env` loading in debug (never committed; see `.env.example`) |
| `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage` | auth/db/storage (Phase 3+) — included now so the folder/DI seams are ready |
| `fl_chart` | progress charts (Phase 11) |
| `file_picker` | PDF upload (Phase 7) |
| `flutter_riverpod` | *not used* — picked `provider` instead to keep one state-mgmt approach; listed here only to note the deliberate choice |

Dev dependencies: `flutter_lints`, `mocktail` (for testing repository interfaces against
fakes).

## 6. Navigation structure

5-tab bottom navigation, each tab a `go_router` branch with its own stack:

```
/home            → HomeScreen
/subjects        → SubjectsScreen        (Phase 4)
  /subjects/:id  → SubjectDetailScreen   (Phase 4)
/ai-tutor        → AiTutorScreen         (Phase 5)
/practice        → PracticeHubScreen     (Phase 6/9)
  /practice/mcq
  /practice/flashcards
  /practice/pyq
  /practice/clinical-case
/profile         → ProfileScreen         (Phase 3/11)
```

Quick actions on Home deep-link into the relevant tab/route (e.g. "Generate MCQ" →
`/practice/mcq`).

## 7. What's included in this delivery

- Full folder scaffold above
- `pubspec.yaml` with the dependencies listed
- Theme (light + dark) — original palette, not copied from any existing app
- `go_router` navigation with the 5-tab shell
- Bottom navigation bar widget
- **Home screen, fully built with realistic mock data**: greeting, streak, prep %,
  continue-studying card, recent topics, weak topics, quick actions grid
- Placeholder screens for the other 4 tabs (so the app runs end-to-end today)
- Mock data + mock repositories so Phase 2 (all screens with mock data) has a real
  pattern to extend rather than starting from scratch
- `AiService` abstract interface + `MockAiService`, ready for Phase 5 to implement for
  real without touching any screen
- `.env.example` documenting required secrets (Firebase config, backend base URL) —
  no real keys anywhere in the repo

## 8. How to run it

1. Install Flutter (stable channel) — https://docs.flutter.dev/get-started/install
2. `cd mbbs_ai_tutor && flutter pub get`
3. Copy `.env.example` to `.env` and fill in values once Phase 3 wires Firebase (not
   required to run Phase 1 — the mock repositories don't need it yet).
4. Run on a connected device/emulator or simulator:
   - Android: `flutter run` (with an Android emulator running, or a device with USB
     debugging enabled)
   - iOS (macOS only): `open ios/Runner.xcworkspace` once, to let Xcode register the
     run destination, then `flutter run` — or `flutter run -d "iPhone 15"` for the
     simulator
5. To just see the Home screen fast: `flutter run -d chrome` also works, since nothing
   in Phase 1 is platform-specific yet.

## 9. Next step

This delivers Phase 1 only, as requested. Reply when ready for **Phase 2** (all
remaining screens built against mock data) and I'll continue from this scaffold.
