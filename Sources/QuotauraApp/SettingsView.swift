import SwiftUI

struct SettingsView: View {
    @ObservedObject var state: AppState
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("openOnHover") private var openOnHover = true
    @AppStorage("showRemainingUsage") private var showRemainingUsage = true

    var body: some View {
        Form {
            Section("Barra de menús") {
                Toggle("Abrir el panel al pasar el cursor", isOn: $openOnHover)
                Toggle("Mostrar porcentaje disponible", isOn: $showRemainingUsage)
            }

            Section("Educación") {
                Button("Mostrar nuevamente la introducción") {
                    hasCompletedOnboarding = false
                }
            }

            Section("Prototipo") {
                Text("Esta compilación utiliza datos de demostración. Ninguna cuenta está conectada todavía.")
                    .foregroundStyle(.secondary)
            }
        }
        .formStyle(.grouped)
        .frame(width: 480, height: 330)
        .navigationTitle("Quotaura")
    }
}
