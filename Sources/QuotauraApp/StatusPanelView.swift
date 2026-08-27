import SwiftUI

struct StatusPanelView: View {
    @ObservedObject var state: AppState
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()

            if hasCompletedOnboarding {
                dashboard
            } else {
                OnboardingView {
                    hasCompletedOnboarding = true
                }
            }
        }
        .frame(width: 430, height: 640)
    }

    private var dashboard: some View {
        ScrollView {
            VStack(spacing: 16) {
                header
                demandBanner

                ForEach(state.providers) { provider in
                    ProviderCard(provider: provider)
                }

                educationCard
                prototypeControls
            }
            .padding(18)
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text("Quotaura")
                    .font(.title2.bold())
                Text("Tu capacidad de trabajo, siempre visible")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button {
                Task { await state.refresh() }
            } label: {
                Image(systemName: state.isRefreshing ? "arrow.triangle.2.circlepath" : "arrow.clockwise")
            }
            .buttonStyle(.borderless)
            .help("Actualizar")
        }
    }

    private var demandBanner: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(state.globalDemand.color)
                .frame(width: 9, height: 9)
            VStack(alignment: .leading, spacing: 2) {
                Text(state.globalDemand.label)
                    .font(.subheadline.weight(.semibold))
                Text("Podrías experimentar un desempeño distinto al habitual.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(12)
        .background(state.globalDemand.color.opacity(0.11), in: RoundedRectangle(cornerRadius: 14))
    }

    private var educationCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Optimiza antes de consumir", systemImage: "graduationcap.fill")
                .font(.headline)

            if let guide = state.guides.first {
                Text(guide.title)
                    .font(.subheadline.weight(.semibold))
                Text(guide.summary)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(guide.estimatedSaving)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.green)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(.white.opacity(0.12)))
    }

    private var prototypeControls: some View {
        VStack(spacing: 8) {
            Button("Simular solicitud a Gemini") {
                state.simulateGeminiRequest()
            }
            .buttonStyle(.borderedProminent)

            Text("Datos de demostración · Las integraciones reales se conectarán en la siguiente fase.")
                .font(.caption2)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
        }
        .padding(.bottom, 6)
    }
}

private struct ProviderCard: View {
    let provider: ProviderUsage

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: provider.symbol)
                    .frame(width: 22)
                VStack(alignment: .leading, spacing: 1) {
                    Text(provider.name)
                        .font(.headline)
                    Text(provider.planName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Label(provider.demand.label, systemImage: "circle.fill")
                    .font(.caption)
                    .foregroundStyle(provider.demand.color)
            }

            ForEach(provider.windows) { window in
                UsageRow(window: window)
            }

            if let spend = provider.apiSpend, let budget = provider.apiBudget {
                HStack {
                    Text("API")
                    Spacer()
                    Text("$\(spend.description) de $\(budget.description)")
                        .foregroundStyle(.secondary)
                }
                .font(.caption)
            }

            if provider.refreshAvailable {
                Label("Restauración disponible en el proveedor", systemImage: "arrow.counterclockwise.circle.fill")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.blue)
            }

            Text("Actualizado \(provider.lastUpdated.formatted(.relative(presentation: .named))) · \(provider.demandConfidence.rawValue)")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(14)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(.white.opacity(0.14)))
    }
}

private struct UsageRow: View {
    let window: UsageWindow

    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text(window.period.rawValue)
                Spacer()
                Text("\(window.remainingPercent)% disponible")
                    .foregroundStyle(.secondary)
                if let reset = window.resetDate {
                    Text("· \(reset.formatted(.relative(presentation: .numeric)))")
                        .foregroundStyle(.tertiary)
                }
            }
            .font(.caption)

            ProgressView(value: window.usedFraction)
                .tint(barColor)
        }
    }

    private var barColor: Color {
        switch window.usedFraction {
        case 0..<0.7: .green
        case 0.7..<0.9: .orange
        default: .red
        }
    }
}
