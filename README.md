# GenFinance

A native iOS demo of **on-device generative UI** — UI components and layouts picked and shaped by an LLM at runtime. Personal-finance theme, three tabs, all data local.

The UI is built dynamically by Apple's Foundation Models framework (the on-device ~3B-param LLM that powers Apple Intelligence). The user types or speaks something, and a different native SwiftUI screen materializes for whatever they asked.

## Tabs

| Tab | What it demonstrates |
|---|---|
| **Ask** | Component-pick variety. Type a finance question; the model assembles a dashboard from a vocabulary of 6 card types (stat / category donut / time series / merchant list / comparison / advice). Different questions → different card mixes. |
| **Plan** | Shape variety, streamed. Type any finance task; the model picks the right *shape* of response (savings plan / dispute form / budget editor / scenario compare) and streams it in. |
| **Speak** | Voice → action UI variety. Tap the mic, say anything; WhisperKit transcribes locally, the model picks the appropriate confirmation UI (log expense / quick insight / set goal / adjust budget). |

## Requirements

- **Xcode 26** or newer
- **iOS 26.4** deployment target
- A device or simulator with **Apple Intelligence enabled** (iPhone 15 Pro / 16 / 17 series, M-series iPad, or recent Apple Silicon Mac for Mac Catalyst — though the project targets iPhone only)

## First-run setup (in Xcode)

1. Open `GenFinance.xcodeproj` in Xcode 26.
2. Select the `GenFinance` target → Signing & Capabilities → set your Development Team.
3. **Add Swift Package dependencies** (File ▸ Add Package Dependencies…):
   - `https://github.com/argmaxinc/WhisperKit` — required for the Speak tab. Add `WhisperKit` to the **GenFinance** target.
   - `https://github.com/pointfreeco/swift-snapshot-testing` — optional, for `CardRendererSnapshotTests`. Add `SnapshotTesting` to the **GenFinanceTests** target.
4. Run on an Apple-Intelligence-capable device or simulator. The app shows a gate screen if Apple Intelligence is unavailable.

The Speak tab works without WhisperKit — it'll just show an actionable error pointing you to step 3.

## Architecture

```
GenFinance/
  App/                 GenFinanceApp + AvailabilityGate
  Core/
    LLM/               LLMService protocol + Live/Stub + SessionFactory (one session per feature)
    Generable/         @Generable types: Card, PlanResponse, VoiceAction, Category
    Tools/             QueryTransactionsTool (Foundation Models tool) + Save/SetGoal/AdjustBudget actions
    Data/              TransactionStore / BudgetStore / GoalStore + 6-month seed data
  Features/
    Ask/               AskView + 6 card renderers
    Plan/              PlanView + 4 plan renderers (streaming PartiallyGenerated)
    Speak/             SpeakView + WhisperRecorder + 4 result renderers
  DesignSystem/        GenerativeCard, SkeletonText, StarterPromptChip, Theme
GenFinanceTests/       Tool spy tests + seed integrity tests + (optional) snapshot tests
```

The pattern in one sentence: **the LLM emits a `@Generable` discriminated-union enum, a SwiftUI `switch` renders each case as a native view.** Streaming is "free" — `PartiallyGenerated` mirrors give every field as optional, so `SkeletonText` swaps in for nil values until the stream fills them.

## Verifying the demo

1. Run on an A17 Pro+ device or simulator with Apple Intelligence enabled.
2. **Ask**: tap the four starter prompts in turn — observe visibly different card layouts.
3. **Plan**: type each of these and watch four different native screens materialize:
   - "Save $5,000 for Tokyo by November"
   - "Help me dispute the $89 charge from yesterday"
   - "Build me a monthly budget for groceries and dining"
   - "What if I cut my dining spending in half?"
4. **Speak**: tap the mic and try:
   - "Spent twenty-three dollars on lunch at Sweetgreen"
   - "How much did I spend on coffee last month?"
   - "Save two hundred dollars a month for emergencies"
   - "Lower my dining budget to three hundred"
5. **Regenerate**: hit regenerate on the same prompt 3× — output should vary (different cards/order).
6. **Availability fallback**: Settings ▸ Apple Intelligence ▸ off → app shows the gate screen.

## What's intentionally out of scope

- Real bank account integration — all data is local seed data.
- MLX Swift / non-Apple-Intelligence fallback.
- Custom LoRA adapter training.
- iPad / Mac Catalyst layouts.
- Localization beyond en-US.
