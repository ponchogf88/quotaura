import Foundation
import SwiftUI

enum DemandLevel: String, Codable, CaseIterable {
    case low
    case elevated
    case peak
    case unknown

    var label: String {
        switch self {
        case .low: "Demanda baja"
        case .elevated: "Demanda elevada"
        case .peak: "Hora pico"
        case .unknown: "Sin datos"
        }
    }

    var color: Color {
        switch self {
        case .low: .green
        case .elevated: .orange
        case .peak: .red
        case .unknown: .secondary
        }
    }
}

enum DataConfidence: String, Codable {
    case official = "Oficial"
    case observed = "Observado"
    case estimated = "Estimado"
    case unavailable = "No disponible"
}

enum UsagePeriod: String, Codable, CaseIterable, Identifiable {
    case session = "Horas"
    case week = "Semana"
    case month = "Mes"

    var id: String { rawValue }
}

struct UsageWindow: Identifiable, Codable, Hashable {
    let id: UUID
    let period: UsagePeriod
    var usedFraction: Double
    var resetDate: Date?
    var confidence: DataConfidence

    init(
        id: UUID = UUID(),
        period: UsagePeriod,
        usedFraction: Double,
        resetDate: Date?,
        confidence: DataConfidence
    ) {
        self.id = id
        self.period = period
        self.usedFraction = min(max(usedFraction, 0), 1)
        self.resetDate = resetDate
        self.confidence = confidence
    }

    var usedPercent: Int { Int((usedFraction * 100).rounded()) }
    var remainingPercent: Int { 100 - usedPercent }
}

struct ProviderUsage: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let symbol: String
    let planName: String
    var demand: DemandLevel
    var demandConfidence: DataConfidence
    var windows: [UsageWindow]
    var apiSpend: Decimal?
    var apiBudget: Decimal?
    var refreshAvailable: Bool
    var lastUpdated: Date

    init(
        id: UUID = UUID(),
        name: String,
        symbol: String,
        planName: String,
        demand: DemandLevel,
        demandConfidence: DataConfidence,
        windows: [UsageWindow],
        apiSpend: Decimal? = nil,
        apiBudget: Decimal? = nil,
        refreshAvailable: Bool = false,
        lastUpdated: Date = .now
    ) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.planName = planName
        self.demand = demand
        self.demandConfidence = demandConfidence
        self.windows = windows
        self.apiSpend = apiSpend
        self.apiBudget = apiBudget
        self.refreshAvailable = refreshAvailable
        self.lastUpdated = lastUpdated
    }

    var mostConstrainedWindow: UsageWindow? {
        windows.max(by: { $0.usedFraction < $1.usedFraction })
    }
}

struct LearningGuide: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let summary: String
    let icon: String
    let estimatedSaving: String
}
