import XCTest
@testable import QuotauraApp

@MainActor
final class AppStateTests: XCTestCase {
    func testGlobalRemainingUsesMostConstrainedWindow() {
        let state = AppState.preview
        XCTAssertEqual(state.globalRemainingPercent, 9)
    }

    func testPeakDemandHasPriority() {
        let state = AppState.preview
        XCTAssertEqual(state.globalDemand, .peak)
    }

    func testSimulatedRequestConsumesFourPercent() {
        let state = AppState.preview
        let before = state.providers
            .first(where: { $0.name == "Gemini" })?
            .windows.first(where: { $0.period == .session })?
            .usedFraction

        state.simulateGeminiRequest()

        let after = state.providers
            .first(where: { $0.name == "Gemini" })?
            .windows.first(where: { $0.period == .session })?
            .usedFraction

        XCTAssertEqual(before, 0.91)
        XCTAssertNotNil(after)
        XCTAssertEqual(after ?? 0, 0.95, accuracy: 0.0001)
    }
}
