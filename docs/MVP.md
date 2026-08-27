# Quotaura MVP specification

## Product promise

Never discover your AI limit when it is already too late to finish the work.

## Primary user

An individual, freelancer, entrepreneur, or small-business owner who pays for multiple personal AI subscriptions and may also use APIs or local AI tools.

## Five pillars

1. Visibility: capacity is as glanceable as the time.
2. Prevention: forecast interruption before it happens.
3. Explanation: attribute consumption to a provider, product, model, and task when data allows.
4. Education: teach legitimate, contextual optimization practices.
5. Continuity: prepare safe alternatives when a quota is exhausted.

## MVP boundary

The first release is macOS-only and does not orchestrate agents. It establishes the menu-bar experience, quota model, educational onboarding, confidence labels, alerts, and one trustworthy provider integration.

## Data confidence contract

Every displayed metric must be one of:

- Official: returned or displayed by the provider.
- Observed: measured locally from authorized activity.
- Estimated: inferred from historical behavior.
- Unavailable: the provider does not expose the necessary data.

## Release sequence

### Milestone 1 — Experience prototype

- Menu-bar indicator and hover panel.
- Demo providers and quota windows.
- Education-first onboarding.
- Manual simulation of consumption.

### Milestone 2 — Real local data

- One local CLI integration.
- Per-request updates.
- 75% and 90% notifications.
- Local-only usage history.

### Milestone 3 — Personal account coverage

- Additional providers where official or safe integrations exist.
- Manual tracking fallback.
- Provider-issued restoration detection.
- Demand state from official status and personal telemetry.

### Milestone 4 — Paid intelligence

- Forecasting and task budgets.
- Product and model attribution.
- Continuity recommendations.
- Cross-device history with explicit consent.

## Out of scope for MVP

- Automatic transfer of private conversations between providers.
- Browser-cookie extraction.
- Agent swarms and orchestration control.
- Claims that demand level determines response quality.
- Unsupported exact token counts for opaque personal subscriptions.
