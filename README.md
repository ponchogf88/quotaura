# Quotaura

Quotaura is a personal AI capacity manager for macOS. It keeps the most constrained AI quota visible beside the clock, warns before work is interrupted, and teaches legitimate ways to make subscriptions and API budgets last longer.

## Current MVP

- Native macOS menu-bar app.
- Persistent `AI 9%`-style indicator.
- Popover on hover or click.
- Hourly/session, weekly, and monthly usage windows.
- Demand indicator with explicit data confidence.
- Separate API spend and subscription usage.
- Provider-issued restoration availability.
- Two-step educational onboarding.
- Simulated Gemini request to demonstrate near-real-time updates.

All current provider values are demo data. The interface labels them accordingly and does not access credentials.

## Run on a Mac

1. Install Xcode 15 or later.
2. Open `Package.swift` in Xcode.
3. Select the `Quotaura` executable scheme.
4. Run the app on macOS 14 or later.
5. Look for `AI 9%` in the menu bar.

The project intentionally uses a Swift Package so it can be opened without generating and committing a machine-specific `.xcodeproj`.

## Product architecture

- `StatusBarController`: owns the macOS status item, hover behavior, and popover.
- `AppState`: aggregates providers and exposes the global constraint.
- `ProviderUsage`: distinguishes plan windows, API budget, demand, and restoration status.
- `ProviderClient`: contract for future official/local integrations.
- `StatusPanelView`: quick glance panel.
- `OnboardingView`: education-first setup.

## Next implementation milestone

Build one reliable provider integration end to end before adding breadth:

1. Read local Codex or Claude Code usage logs with user permission.
2. Store no conversation content; extract only timestamps, model, token counts, and cost metadata.
3. Mark every metric as official, observed, estimated, or unavailable.
4. Add threshold notifications at 75% and 90%.
5. Compare the local reading with the provider's own usage display.

## Principles

- Never invent precision.
- Never present a local counter reset as a provider restoration.
- Keep credentials in macOS Keychain.
- Prefer local processing and minimal telemetry.
- Explain recommendations before automating them.
