import Foundation

/// Contract for future provider integrations. Implementations must identify
/// whether each value is official, observed, estimated, or unavailable.
protocol ProviderClient: Sendable {
    var providerName: String { get }
    func fetchUsage() async throws -> ProviderUsage
}

enum ProviderClientError: LocalizedError {
    case authenticationRequired
    case unsupportedAccount
    case rateLimited(retryAfter: Date?)
    case unavailable

    var errorDescription: String? {
        switch self {
        case .authenticationRequired:
            "Es necesario conectar la cuenta."
        case .unsupportedAccount:
            "Este tipo de cuenta no publica datos de consumo."
        case .rateLimited(let retryAfter):
            retryAfter.map { "El proveedor limitó la consulta hasta \($0.formatted())." }
                ?? "El proveedor limitó temporalmente la consulta."
        case .unavailable:
            "El proveedor no está disponible."
        }
    }
}
