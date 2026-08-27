import Combine
import Foundation

@MainActor
final class AppState: ObservableObject {
    @Published var providers: [ProviderUsage]
    @Published var guides: [LearningGuide]
    @Published var isRefreshing = false
    @Published var selectedProviderID: ProviderUsage.ID?

    init(providers: [ProviderUsage], guides: [LearningGuide]) {
        self.providers = providers
        self.guides = guides
        self.selectedProviderID = providers.first?.id
    }

    var globalRemainingPercent: Int {
        let constrained = providers.compactMap { provider in
            provider.mostConstrainedWindow?.remainingPercent
        }
        guard !constrained.isEmpty else { return 0 }
        return constrained.min() ?? 0
    }

    var globalDemand: DemandLevel {
        if providers.contains(where: { $0.demand == .peak }) { return .peak }
        if providers.contains(where: { $0.demand == .elevated }) { return .elevated }
        if providers.contains(where: { $0.demand == .low }) { return .low }
        return .unknown
    }

    func refresh() async {
        guard !isRefreshing else { return }
        isRefreshing = true
        defer { isRefreshing = false }

        // MVP: simulated latency. Provider clients will replace this in Phase 2.
        try? await Task.sleep(for: .milliseconds(450))
        let now = Date.now
        for index in providers.indices {
            providers[index].lastUpdated = now
        }
    }

    func simulateGeminiRequest() {
        guard let providerIndex = providers.firstIndex(where: { $0.name == "Gemini" }),
              let sessionIndex = providers[providerIndex].windows.firstIndex(where: { $0.period == .session })
        else { return }

        providers[providerIndex].windows[sessionIndex].usedFraction += 0.04
        providers[providerIndex].windows[sessionIndex].usedFraction = min(
            providers[providerIndex].windows[sessionIndex].usedFraction,
            1
        )
        providers[providerIndex].lastUpdated = .now
    }
}

extension AppState {
    static var preview: AppState {
        AppState(
            providers: [
            ProviderUsage(
                name: "ChatGPT",
                symbol: "sparkles",
                planName: "Pro",
                demand: .elevated,
                demandConfidence: .observed,
                windows: [
                    UsageWindow(period: .session, usedFraction: 0.42, resetDate: .now.addingTimeInterval(42 * 60), confidence: .official),
                    UsageWindow(period: .week, usedFraction: 0.54, resetDate: .now.addingTimeInterval(4 * 86_400), confidence: .official),
                    UsageWindow(period: .month, usedFraction: 0.36, resetDate: .now.addingTimeInterval(18 * 86_400), confidence: .estimated)
                ],
                apiSpend: 18.40,
                apiBudget: 30
            ),
            ProviderUsage(
                name: "Claude",
                symbol: "brain.head.profile",
                planName: "Max",
                demand: .low,
                demandConfidence: .official,
                windows: [
                    UsageWindow(period: .session, usedFraction: 0.28, resetDate: .now.addingTimeInterval(2.2 * 3_600), confidence: .official),
                    UsageWindow(period: .week, usedFraction: 0.46, resetDate: .now.addingTimeInterval(5 * 86_400), confidence: .official),
                    UsageWindow(period: .month, usedFraction: 0.22, resetDate: nil, confidence: .unavailable)
                ],
                refreshAvailable: true
            ),
            ProviderUsage(
                name: "Gemini",
                symbol: "diamond",
                planName: "AI Pro",
                demand: .peak,
                demandConfidence: .estimated,
                windows: [
                    UsageWindow(period: .session, usedFraction: 0.91, resetDate: .now.addingTimeInterval(58 * 60), confidence: .observed),
                    UsageWindow(period: .week, usedFraction: 0.63, resetDate: .now.addingTimeInterval(2 * 86_400), confidence: .estimated),
                    UsageWindow(period: .month, usedFraction: 0.71, resetDate: .now.addingTimeInterval(8 * 86_400), confidence: .official)
                ]
            )
            ],
            guides: [
            LearningGuide(
                title: "Reduce el contexto del proyecto",
                summary: "Crea un mapa breve y permite que el agente abra solo los archivos necesarios.",
                icon: "map",
                estimatedSaving: "20–40% estimado"
            ),
            LearningGuide(
                title: "Separa tareas y conversaciones",
                summary: "Transporta un resumen útil en lugar de reutilizar historiales extensos.",
                icon: "arrow.triangle.branch",
                estimatedSaving: "15–35% estimado"
            ),
            LearningGuide(
                title: "Prepara una alternativa",
                summary: "Configura un modelo auxiliar antes de alcanzar el límite de tu proveedor principal.",
                icon: "lifepreserver",
                estimatedSaving: "Continuidad protegida"
            )
            ]
        )
    }
}
